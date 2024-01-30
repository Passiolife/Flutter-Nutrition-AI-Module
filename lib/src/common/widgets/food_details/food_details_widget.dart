import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../pages/edit_food/edit_food_page.dart';
import '../../../pages/food_search/food_search_page.dart';
import '../../constant/app_constants.dart';
import '../../constant/dimens.dart';
import '../../models/food_record/food_record.dart';
import '../../util/context_extension.dart';
import '../../util/double_extensions.dart';
import '../../util/string_extensions.dart';
import 'bloc/food_details_bloc.dart';
import 'dialogs/rename_food_dialogs.dart';
import 'widgets/food_detail_header.dart';
import 'widgets/ingredients_widget.dart';
import 'widgets/meal_time_widget.dart';
import 'widgets/serving_size_view_widget.dart';
import 'widgets/visual_alternative_widget.dart';

class FoodDetailsWidget extends StatefulWidget {
  final FoodRecord? foodRecord;
  final bool isMealTimeVisible;
  final bool isIngredientsVisible;

  const FoodDetailsWidget(
      {this.foodRecord,
      this.isMealTimeVisible = true,
      this.isIngredientsVisible = true,
      super.key});

  @override
  State<FoodDetailsWidget> createState() => FoodDetailsWidgetState();
}

class FoodDetailsWidgetState extends State<FoodDetailsWidget>
    with TickerProviderStateMixin {
  /// [_bloc] is use to call the events and listening the states.
  final _bloc = FoodDetailsBloc();

  /// [_updatedFoodRecord] is clone of [_updatedFoodRecord],
  /// but this object contains the updated changes.
  FoodRecord? _updatedFoodRecord;

  FoodRecord? get updatedFoodRecord => _updatedFoodRecord;

  /// below are the tags for the [Hero] widget.
  PassioID get _tagPassioId => _updatedFoodRecord?.passioID ?? 'tagPassioId';

  String get _tagName => _updatedFoodRecord?.name ?? 'tagName';

  String get _tagSubtitle => AppConstants.subtitle;

  String get _tagCalories => context.localization?.calories ?? 'tagCalories';

  String get _tagCaloriesData => AppConstants.calories;

  /// Getting food name from the food record.
  String get _title => _updatedFoodRecord?.name?.toUpperCaseWord ?? '';

  /// Getting nutrition from the food record.
  String get _subTitle =>
      "${(_updatedFoodRecord?.selectedQuantity ?? 1).removeDecimalZeroFormat} ${_updatedFoodRecord?.selectedUnit ?? ""} "
      "(${_updatedFoodRecord?.computedWeight.value.removeDecimalZeroFormat ?? ""} ${_updatedFoodRecord?.computedWeight.symbol ?? ""})";

  // Get total calories from food.
  String get _totalCalories =>
      (_updatedFoodRecord?.totalCalories.toInt() ?? 0).toString();

  String get _totalCarbs =>
      "${(_updatedFoodRecord?.totalCarbs ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.ingredients?.firstOrNull?.totalCarbs()?.unit.symbol ?? ""}";

  String get _totalProteins =>
      "${(_updatedFoodRecord?.totalProteins ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.ingredients?.firstOrNull?.totalProteins()?.unit.symbol ?? ""}";

  String get _totalFat =>
      "${(_updatedFoodRecord?.totalFat ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.ingredients?.firstOrNull?.totalFat()?.unit.symbol ?? ""}";

  /// [_quantityController] is use to update and get the value from quantity text field.
  final TextEditingController _quantityController = TextEditingController();

  // [sliderValue] is defines the position of slider.
  // [sliderMaximum] is maximum value the user can select.
  SliderData _sliderData =
      (sliderValue: 0.0001, sliderStep: 1, sliderMin: 0.0001, sliderMax: 1.0);

  PassioServingSize? _selectedServingSize;

  List<PassioAlternative?> get _alternatives =>
      (_updatedFoodRecord?.parents ?? []) +
      (_updatedFoodRecord?.siblings ?? []) +
      (_updatedFoodRecord?.children ?? []);

  // [visibleEditAmountButton] use in FoodDetailHeader to show the "Edit Amount" button.
  bool _visibleEditAmountButton = false;

  // [visibleCloseButton] use in [ServingSizeViewWidget] to show the "Close" button.
  bool _visibleCloseButton = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SliderUpdateState) {
          _handleSliderUpdateState(state: state);
        } else if (state is AlternateSuccessState) {
          _handleAlternateSuccessState(state: state);
        }

        ///
        else if (state is UpdateAmountEditableState) {
          _handleUpdateAmountEditableState(state: state);
        }
      },
      builder: (context, state) {
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: Dimens.duration300),
          firstChild: SingleChildScrollView(
            child: Column(
              children: [
                FoodDetailHeader(
                  key: ValueKey(_updatedFoodRecord?.passioID),
                  passioID: _updatedFoodRecord?.passioID,
                  entityType:
                      _updatedFoodRecord?.entityType ?? PassioIDEntityType.item,
                  title: _title,
                  subTitle: _subTitle,
                  totalCalories: _totalCalories,
                  totalCarbs: _totalCarbs,
                  totalProteins: _totalProteins,
                  totalFat: _totalFat,
                  tagPassioId: _tagPassioId,
                  tagName: _tagName,
                  tagSubtitle: _tagSubtitle,
                  tagCalories: _tagCalories,
                  tagCaloriesData: _tagCaloriesData,
                  isEditAmountVisible: _visibleEditAmountButton,
                  onTapEditAmount: () {
                    _bloc.add(DoUpdateAmountEditableEvent(isEditable: true));
                  },
                  onTapTitle: () {
                    RenameFoodDialogs.show(
                      context: context,
                      text: _title,
                      title: context.localization?.renameFoodRecord ?? '',
                      onRenameFood: (value) {
                        _updatedFoodRecord?.name = value;
                      },
                    );
                  },
                ),
                Dimens.h4.verticalSpace,
                ServingSizeViewWidget(
                  quantityController: _quantityController,
                  selectedServingUnitName: _updatedFoodRecord?.selectedUnit,
                  servingUnits: _updatedFoodRecord?.servingUnits,
                  onChangeServingUnit: (PassioServingUnit? servingUnit) {
                    _bloc.add(DoUpdateUnitKeepWeightEvent(
                        data: _updatedFoodRecord,
                        selectedUnitName: servingUnit?.unitName ?? ''));
                  },
                  computedWeight: _updatedFoodRecord?.computedWeight,
                  sliderData: _sliderData,
                  onQuantityChange: (fromSlider, value) {
                    _bloc.add(DoUpdateQuantityEvent(
                        data: _updatedFoodRecord,
                        updatedQuantity: value,
                        shouldReset: !fromSlider));
                  },
                  servingSizes: _updatedFoodRecord?.servingSizes,
                  selectedServingSize: _selectedServingSize,
                  onServingSizeChange: (servingSize) {
                    _bloc.add(DoUpdateServingSizeEvent(
                      updatedUnitName: servingSize?.unitName,
                      updatedQuantity: servingSize?.quantity,
                      data: _updatedFoodRecord,
                    ));
                  },
                  isCloseVisible: _visibleCloseButton,
                  onTapCloseEdit: () {
                    _bloc.add(DoUpdateAmountEditableEvent(isEditable: false));
                  },
                ),
                Dimens.h4.verticalSpace,
                VisualAlternativeWidget(
                  alternatives: _alternatives,
                  onTapAlternative: (alternative) {
                    _bloc
                        .add(DoAlternateEvent(passioID: alternative?.passioID));
                  },
                ),
                if (widget.isMealTimeVisible) ...[
                  Dimens.h4.verticalSpace,
                  MealTimeWidget(
                    selectedMealLabel: _updatedFoodRecord?.mealLabel,
                    onUpdateMealTime: (label) {
                      _updatedFoodRecord?.mealLabel = label;
                    },
                  ),
                ],
                if (widget.isIngredientsVisible) ...[
                  Dimens.h8.verticalSpace,
                  IngredientsWidget(
                    data: _updatedFoodRecord?.ingredients,
                    onTapAddIngredients: _handleOnTapAddIngredients,
                    onDeleteItem: _handleDeleteItem,
                    onEditItem: _handleOnEditItem,
                  ),
                ],
              ],
            ),
          ),
          secondChild: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              FoodDetailHeader(
                key: ValueKey(_updatedFoodRecord?.passioID),
                passioID: _updatedFoodRecord?.passioID,
                entityType:
                    _updatedFoodRecord?.entityType ?? PassioIDEntityType.item,
                title: _title,
                subTitle: _subTitle,
                totalCalories: _totalCalories,
                totalCarbs: _totalCarbs,
                totalProteins: _totalProteins,
                totalFat: _totalFat,
                tagPassioId: _tagPassioId,
                tagName: _tagName,
                tagSubtitle: _tagSubtitle,
                tagCalories: _tagCalories,
                tagCaloriesData: _tagCaloriesData,
                isEditAmountVisible: _visibleEditAmountButton,
                onTapEditAmount: () {
                  _bloc.add(DoUpdateAmountEditableEvent(isEditable: true));
                },
                onTapTitle: () {
                  RenameFoodDialogs.show(
                    context: context,
                    text: _title,
                    title: context.localization?.renameFoodRecord ?? '',
                    onRenameFood: (value) {
                      _updatedFoodRecord?.name = value;
                    },
                  );
                },
              ),
              Dimens.h4.verticalSpace,
              VisualAlternativeWidget(
                alternatives: _alternatives,
                onTapAlternative: (alternative) {
                  _bloc.add(DoAlternateEvent(passioID: alternative?.passioID));
                },
              ),
              if (widget.isMealTimeVisible) ...[
                Dimens.h4.verticalSpace,
                MealTimeWidget(
                  selectedMealLabel: _updatedFoodRecord?.mealLabel,
                  onUpdateMealTime: (label) {
                    _updatedFoodRecord?.mealLabel = label;
                  },
                ),
              ],
              if (widget.isIngredientsVisible) ...[
                Dimens.h8.verticalSpace,
                IngredientsWidget(
                  data: _updatedFoodRecord?.ingredients,
                  onTapAddIngredients: _handleOnTapAddIngredients,
                  onDeleteItem: _handleDeleteItem,
                  onEditItem: _handleOnEditItem,
                ),
              ],
            ],
          ),
          crossFadeState: _visibleCloseButton
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        );
      },
    );
  }

  void _initialize() {
    _updatedFoodRecord = widget.foodRecord;

    /// Here checking ingredients count if it is more than 1 then editable is not visible by default,
    /// else we will show the editable widget.
    _visibleCloseButton = (_updatedFoodRecord?.ingredients?.length ?? 0) <= 1;
    _visibleEditAmountButton =
        (_updatedFoodRecord?.ingredients?.length ?? 0) > 1;
    _updateSelectedPassioServingSize();
    _bloc.add(DoSliderUpdateEvent(
      data: _updatedFoodRecord,
      shouldReset: true,
    ));
  }

  Future _handleOnTapAddIngredients() async {
    final data = await FoodSearchPage.navigate(context);
    if (data != null && data is PassioIDAndName?) {
      _bloc.add(DoAddIngredientsEvent(
          data: _updatedFoodRecord, ingredientData: data));
    }
  }

  void _handleDeleteItem(int index) {
    _bloc.add(DoRemoveIngredientsEvent(index: index, data: _updatedFoodRecord));
  }

  Future<void> _handleOnEditItem(int index) async {
    FoodRecord? data = await EditFoodPage.navigate(
      context,
      foodRecord: FoodRecord.from(
          passioFoodItemData:
              _updatedFoodRecord?.ingredients?.elementAt(index)),
      index: index,
      isFromEdit: true,
    );
    _bloc.add(DoUpdateIngredientEvent(
        atIndex: index,
        data: _updatedFoodRecord,
        updatedFoodItemData: data?.toFoodItem));
  }

  void _handleSliderUpdateState({required SliderUpdateState state}) {
    _sliderData = state.sliderData;

    _updateSelectedPassioServingSize();

    // Updating the text field value.
    _quantityController.text = _sliderData.sliderValue.removeDecimalZeroFormat;
  }

  void _updateSelectedPassioServingSize() {
    _selectedServingSize = PassioServingSize(
        _updatedFoodRecord?.selectedQuantity ?? 0,
        _updatedFoodRecord?.selectedUnit ?? '');
  }

  void _handleAlternateSuccessState({required AlternateSuccessState state}) {
    _updatedFoodRecord = state.data;
  }

  void _handleUpdateAmountEditableState(
      {required UpdateAmountEditableState state}) {
    _visibleEditAmountButton = !state.isEditable;

    _visibleCloseButton = state.isEditable;
  }
}
