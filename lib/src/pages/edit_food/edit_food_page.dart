import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/food_record/food_record_ingredient.dart';
import '../../common/models/food_record/food_record_v3.dart';
import '../../common/models/food_record/meal_label.dart';
import '../../common/router/routes.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/double_extensions.dart';
import '../../common/widgets/app_button.dart';
import 'bloc/edit_food_bloc.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/typedefs.dart';
import 'widgets/widgets.dart';

class EditFoodPage extends StatefulWidget {
  const EditFoodPage._(
    this.foodItem,
    this.foodRecord,
    this.foodRecordIngredient, {
    this.needsReturn = false,
    this.visibleFoodHeaderView = true,
    this.visibleServingSizeView = true,
    this.visibleMealTimeView = true,
    this.visibleDateView = true,
    this.visibleAddIngredient = true,
    this.visibleOpenFoodFacts = true,
    this.visibleMoreDetails = true,
    this.iconHeroTag,
  });

  final PassioFoodItem? foodItem;
  final FoodRecord? foodRecord;
  final FoodRecordIngredient? foodRecordIngredient;

  final bool needsReturn;

  final bool visibleFoodHeaderView;
  final bool visibleServingSizeView;
  final bool visibleMealTimeView;
  final bool visibleDateView;
  final bool visibleAddIngredient;
  final bool visibleOpenFoodFacts;
  final bool visibleMoreDetails;

  final String? iconHeroTag;

  factory EditFoodPage.fromPassioFoodItem({
    PassioFoodItem? foodItem,
    bool needsReturn = false,
    bool visibleFoodHeaderView = true,
    bool visibleServingSizeView = true,
    bool visibleMealTimeView = true,
    bool visibleDateView = true,
    bool visibleAddIngredient = true,
    bool visibleOpenFoodFacts = true,
    bool visibleMoreDetails = true,
    String? iconHeroTag,
  }) {
    return EditFoodPage._(
      foodItem,
      null,
      null,
      needsReturn: needsReturn,
      visibleFoodHeaderView: visibleFoodHeaderView,
      visibleServingSizeView: visibleServingSizeView,
      visibleMealTimeView: visibleMealTimeView,
      visibleDateView: visibleDateView,
      visibleAddIngredient: visibleAddIngredient,
      visibleMoreDetails: visibleMoreDetails,
      visibleOpenFoodFacts: visibleOpenFoodFacts,
      iconHeroTag: iconHeroTag,
    );
  }

  factory EditFoodPage.fromFoodRecord({
    FoodRecord? foodRecord,
    bool needsReturn = false,
    bool visibleFoodHeaderView = true,
    bool visibleServingSizeView = true,
    bool visibleMealTimeView = true,
    bool visibleDateView = true,
    bool visibleAddIngredient = true,
    bool visibleOpenFoodFacts = true,
    bool visibleMoreDetails = true,
    String? iconHeroTag,
  }) {
    return EditFoodPage._(
      null,
      foodRecord,
      null,
      needsReturn: needsReturn,
      visibleFoodHeaderView: visibleFoodHeaderView,
      visibleServingSizeView: visibleServingSizeView,
      visibleMealTimeView: visibleMealTimeView,
      visibleDateView: visibleDateView,
      visibleAddIngredient: visibleAddIngredient,
      visibleMoreDetails: visibleMoreDetails,
      visibleOpenFoodFacts: visibleOpenFoodFacts,
      iconHeroTag: iconHeroTag,
    );
  }

  factory EditFoodPage.fromFoodRecordIngredient({
    FoodRecordIngredient? foodRecordIngredient,
    bool needsReturn = false,
    bool visibleFoodHeaderView = true,
    bool visibleServingSizeView = true,
    bool visibleMealTimeView = true,
    bool visibleDateView = true,
    bool visibleAddIngredient = true,
    bool visibleOpenFoodFacts = true,
    bool visibleMoreDetails = true,
    String? iconHeroTag,
  }) {
    return EditFoodPage._(
      null,
      null,
      foodRecordIngredient,
      needsReturn: needsReturn,
      visibleFoodHeaderView: visibleFoodHeaderView,
      visibleServingSizeView: visibleServingSizeView,
      visibleMealTimeView: visibleMealTimeView,
      visibleDateView: visibleDateView,
      visibleAddIngredient: visibleAddIngredient,
      visibleMoreDetails: visibleMoreDetails,
      visibleOpenFoodFacts: visibleOpenFoodFacts,
      iconHeroTag: iconHeroTag,
    );
  }

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage>
    implements EditFoodListener {
  bool _isAddedToFavorite = false;
  final _bloc = EditFoodBloc();

  FoodRecord? _foodRecord;
  SliderData? _sliderData;

  @override
  void initState() {
    _bloc.add(DoConversionEvent(
      foodItem: widget.foodItem,
      foodRecordIngredient: widget.foodRecordIngredient,
      foodRecord: widget.foodRecord,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditFoodBloc, EditFoodState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStates(context: context, state: state);
      },
      builder: (context, state) {
        return Scaffold(
          // Set background color
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              const EditFoodAppBarWidget(visibleSwitch: false),
              SizedBox(height: AppDimens.h24),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Visibility(
                          visible: widget.visibleFoodHeaderView,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppDimens.h16),
                            child: FoodHeaderWidget(
                              iconId: _foodRecord?.iconId ?? '',
                              title: _foodRecord?.name,
                              entityType: _foodRecord?.entityType ??
                                  PassioIDEntityType.item,
                              calories: _foodRecord?.totalCalories
                                      .formatNumberToDouble() ??
                                  0,
                              carbs: _foodRecord?.totalCarbs
                                      .formatNumberToDouble() ??
                                  0,
                              proteins: _foodRecord?.totalProteins
                                      .formatNumberToDouble() ??
                                  0,
                              fat: _foodRecord?.totalFat
                                      .formatNumberToDouble() ??
                                  0,
                              iconHeroTag: widget.iconHeroTag,
                              visibleOpenFoodFacts: widget.visibleOpenFoodFacts,
                              visibleMoreDetails: widget.visibleMoreDetails,
                              listener: this,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.visibleServingSizeView,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppDimens.h16),
                            child: ServingSizeWidget(
                              servingSize: _foodRecord?.computedWeight,
                              servingUnits: _foodRecord?.servingUnits ?? [],
                              sliderData: _sliderData,
                              selectedServingUnit:
                                  _foodRecord?.getSelectedUnit(),
                              selectedQuantity: _foodRecord
                                      ?.getSelectedQuantity()
                                      .formatNumberToDouble(places: 2) ??
                                  1,
                              listener: this,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.visibleMealTimeView,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppDimens.h16),
                            child: MealTimeWidget(
                              selectedMealLabel: _foodRecord?.mealLabel,
                              listener: this,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.visibleDateView,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppDimens.h16),
                            child: DateWidget(
                              selectedDate: _foodRecord?.getCreatedAt(),
                              listener: this,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.visibleAddIngredient,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppDimens.h16),
                            child: IngredientWidget(
                              ingredients: _foodRecord?.ingredients ?? [],
                              listener: this,
                            ),
                          ),
                        ),
                        _isAddedToFavorite
                            ? Padding(
                                padding: EdgeInsets.only(top: AppDimens.h8),
                                child: AppButton(
                                  buttonText:
                                      context.localization?.addedToFavorites,
                                  appButtonModel:
                                      AppButtonStyles.primary.copyWith(
                                    decoration: AppButtonStyles
                                        .primary.decoration
                                        ?.copyWith(
                                            color: AppColors.slateGray75),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        SizedBox(height: AppDimens.h16),
                      ],
                    ),
                  ),
                ),
              ),
              ActionButtonsWidget(
                logButtonText: widget.foodRecordIngredient != null
                    ? context.localization?.save
                    : context.localization?.log,
                onTapCancel: () {
                  Navigator.pop(context);
                },
                onTapLog: () {
                  if (widget.needsReturn) {
                    Navigator.pop(context, _foodRecord);
                  } else {
                    _bloc.add(const DoLogEvent());
                  }
                },
              ),
              SizedBox(height: AppDimens.h24),
            ],
          ),
        );
      },
    );
  }

  void _handleStates(
      {required BuildContext context, required EditFoodState state}) {
    if (state is ConversionSuccessState) {
      _foodRecord = state.foodRecord;
      _sliderData = state.sliderData;
    } else if (state is UpdateServingQuantitySuccessState) {
      _foodRecord = state.foodRecord;
      _sliderData = state.sliderData;
    } else if (state is LogSuccessState) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.dashboardPage,
        (route) => false,
        arguments: {AppCommonConstants.page: context.localization?.diary},
      );
    } else if (state is UpdateServingUnitSuccessState) {
      _foodRecord = state.foodRecord;
    }
  }

  @override
  void onChangeDate(DateTime dateTime) {
    _bloc.add(DoUpdateDateEvent(dateTime: dateTime));
  }

  @override
  void onChangeMealTime(MealLabel mealLabel) {
    _bloc.add(DoUpdateMealLabelEvent(mealLabel: mealLabel));
  }

  @override
  void onChangeFavorite(bool isFavorite) {}

  @override
  void onChangeServingQuantity(double quantity, bool resetSlider) {
    _bloc.add(DoUpdateServingQuantityEvent(
        quantity: quantity, resetSlider: resetSlider));
  }

  @override
  Future<void> onAddIngredient() async {
    final data = await Navigator.pushNamed(context, Routes.foodSearchPage);
    if (data != null && data is PassioFoodItem) {
      _bloc.add(DoAddIngredientEvent(foodItem: data));
    }
  }

  @override
  Future<void> onTapIngredient(
      FoodRecordIngredient foodRecordIngredient) async {
    // TODO: here index might be conflicts if same data comes. so test with same data or else add one param in function.
    final index = _foodRecord?.ingredients.indexOf(foodRecordIngredient) ?? 0;
    final data = await Navigator.pushNamed(
      context,
      Routes.editFoodPage,
      arguments: {
        AppCommonConstants.data: foodRecordIngredient.clone(),
        AppCommonConstants.iconHeroTag: '${foodRecordIngredient.iconId}$index',
        AppCommonConstants.titleHeroTag: '${foodRecordIngredient.name}$index',
        AppCommonConstants.needsReturn: true,
      },
    );
    if (data != null && data is FoodRecord) {
      _bloc.add(DoReplaceIngredientEvent(index: index, ingredient: data));
    }
  }

  @override
  void onDeleteIngredient(FoodRecordIngredient foodRecordIngredient) {
    _bloc.add(DoRemoveIngredientEvent(ingredient: foodRecordIngredient));
  }

  @override
  void onChangeServingUnit(String unit) {
    _bloc.add(DoUpdateServingUnitEvent(unit: unit));
  }

  @override
  void onTapMoreDetails() {}

  @override
  void onTapOpenFoodFacts() {}
}
