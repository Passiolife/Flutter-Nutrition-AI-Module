import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_constants.dart';
import '../../common/dialogs/single_text_field_new_dialog.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/models/food_record/food_record_ingredient.dart';
import '../../common/models/food_record/meal_label.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/double_extensions.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import '../dashboard/dashboard_page.dart';
import '../food_search/food_search_page.dart';
import 'bloc/edit_food_bloc.dart';
import 'dialogs/create_recipe_dialog.dart';
import 'dialogs/open_food_facts_dialog.dart';
import 'nutrition_information/nutrition_information_page.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/typedefs.dart';
import 'widgets/widgets.dart';

class EditFoodPage extends StatefulWidget {
  const EditFoodPage._({
    this.foodItem,
    this.foodRecord,
    this.foodRecordIngredient,
    this.detectedCandidate,
    this.searchResult,
    this.needsReturn = false,
    this.isUpdate = false,
    this.visibleFoodHeaderView = true,
    this.visibleServingSizeView = true,
    this.visibleMealTimeView = true,
    this.visibleDateView = true,
    this.visibleAddIngredient = true,
    this.visibleOpenFoodFacts,
    this.visibleMoreDetails = true,
    this.visibleFavorite = true,
    this.visibleSwitch = false,
    this.visibleDelete = false,
    this.redirectToDiaryOnLog = false,
    this.iconHeroTag,
    this.mealLabel,
    this.message,
    this.shouldUpdateServingUnit = false,
  });

  final PassioFoodItem? foodItem;
  final FoodRecord? foodRecord;
  final FoodRecordIngredient? foodRecordIngredient;
  final DetectedCandidate? detectedCandidate;
  final PassioFoodDataInfo? searchResult;

  final bool needsReturn;
  final bool isUpdate;

  final bool redirectToDiaryOnLog;

  final bool visibleFoodHeaderView;
  final bool visibleServingSizeView;
  final bool visibleMealTimeView;
  final bool visibleDateView;
  final bool visibleAddIngredient;
  final bool? visibleOpenFoodFacts;
  final bool visibleMoreDetails;
  final bool visibleSwitch;
  final bool visibleDelete;
  final bool visibleFavorite;

  final String? iconHeroTag;
  final MealLabel? mealLabel;

  final String? message;
  final bool shouldUpdateServingUnit;

  static Future navigate({
    required BuildContext context,
    PassioFoodItem? foodItem,
    FoodRecord? foodRecord,
    FoodRecordIngredient? foodRecordIngredient,
    DetectedCandidate? detectedCandidate,
    PassioFoodDataInfo? passioFoodDataInfo,
    bool needsReturn = false,
    bool isUpdate = false,
    bool visibleFoodHeaderView = true,
    bool visibleServingSizeView = true,
    bool visibleMealTimeView = true,
    bool visibleDateView = true,
    bool visibleAddIngredient = true,
    bool? visibleOpenFoodFacts,
    bool visibleMoreDetails = true,
    bool visibleFavorite = true,
    bool visibleSwitch = false,
    bool visibleDelete = false,
    bool redirectToDiaryOnLog = false,
    String? iconHeroTag,
    MealLabel? mealLabel,
    String? message,
    bool shouldUpdateServingUnit = false,
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EditFoodPage._(
            foodItem: foodItem,
            foodRecord: foodRecord,
            foodRecordIngredient: foodRecordIngredient,
            detectedCandidate: detectedCandidate,
            searchResult: passioFoodDataInfo,
            needsReturn: needsReturn,
            isUpdate: isUpdate,
            visibleFoodHeaderView: visibleFoodHeaderView,
            visibleServingSizeView: visibleServingSizeView,
            visibleMealTimeView: visibleMealTimeView,
            visibleDateView: visibleDateView,
            visibleAddIngredient: visibleAddIngredient,
            visibleOpenFoodFacts: visibleOpenFoodFacts,
            visibleMoreDetails: visibleMoreDetails,
            visibleFavorite: visibleFavorite,
            visibleSwitch: visibleSwitch,
            visibleDelete: visibleDelete,
            redirectToDiaryOnLog: redirectToDiaryOnLog,
            iconHeroTag: iconHeroTag,
            mealLabel: mealLabel,
            message: message,
            shouldUpdateServingUnit: shouldUpdateServingUnit,
          );
        },
      ),
    );
  }

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage>
    implements EditFoodListener, FoodHeaderListener {
  final _bloc = EditFoodBloc();

  FoodRecord? _foodRecord;
  SliderData? _sliderData;

  String _entityTypeName = '';

  bool get _isOpenFood =>
      _foodRecord?.openFoodLicense != null ||
      (_foodRecord?.ingredients
              .any((element) => element.openFoodLicense != null) ??
          false);

  @override
  void initState() {
    _bloc.add(DoConversionEvent(
      foodItem: widget.foodItem,
      foodRecordIngredient: widget.foodRecordIngredient,
      foodRecord: widget.foodRecord,
      detectedCandidate: widget.detectedCandidate,
      foodDataInfo: widget.searchResult,
      mealLabel: widget.mealLabel,
      shouldUpdateServingUnit: widget.shouldUpdateServingUnit,
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
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              CustomAppBarWidget(
                title: context.localization?.edit,
                isMenuVisible: false,
                suffix: (widget.visibleSwitch || widget.visibleDelete)
                    ? IconButton(
                        onPressed: () => widget.visibleDelete
                            ? onDeleteTapped()
                            : onSwitchTapped(),
                        icon: SvgPicture.asset(
                          (widget.visibleDelete)
                              ? AppImages.icTrash
                              : AppImages.icSwitchHorizontal,
                          width: AppDimens.r24,
                          height: AppDimens.r24,
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: IndexedStack(
                  index: (state is ConversionLoadingState) ? 1 : 0,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: AppDimens.h16),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: AppDimens.w16),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: widget.visibleFoodHeaderView,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: AppDimens.h16),
                                      child: FoodHeaderWidget(
                                        iconId: _foodRecord?.iconId ?? '',
                                        title: _foodRecord?.name,
                                        subtitle: _foodRecord?.additionalData,
                                        entityType: _foodRecord?.entityType ??
                                            PassioIDEntityType.item,
                                        calories: _foodRecord?.totalCalories
                                                .parseFormatted() ??
                                            0,
                                        carbs: _foodRecord?.totalCarbs
                                                .parseFormatted() ??
                                            0,
                                        proteins: _foodRecord?.totalProteins
                                                .parseFormatted() ??
                                            0,
                                        fat: _foodRecord?.totalFat
                                                .parseFormatted() ??
                                            0,
                                        isFavorite:
                                            _foodRecord?.isFavorite ?? false,
                                        iconHeroTag: widget.iconHeroTag,
                                        visibleOpenFoodFacts:
                                            widget.visibleOpenFoodFacts ??
                                                _isOpenFood,
                                        visibleMoreDetails:
                                            widget.visibleMoreDetails,
                                        visibleFavorite: widget.visibleFavorite,
                                        listener: this,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.visibleServingSizeView,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: AppDimens.h16),
                                      child: ServingSizeWidget(
                                        servingSize:
                                            _foodRecord?.computedWeight,
                                        servingUnits:
                                            _foodRecord?.servingUnits ?? [],
                                        sliderData: _sliderData,
                                        selectedServingUnit:
                                            _foodRecord?.getSelectedUnit(),
                                        selectedQuantity: _foodRecord
                                                ?.getSelectedQuantity()
                                                .parseFormatted(places: 2) ??
                                            1,
                                        listener: this,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.visibleMealTimeView,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: AppDimens.h16),
                                      child: MealTimeWidget(
                                        selectedMealLabel:
                                            _foodRecord?.mealLabel,
                                        listener: this,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.visibleDateView,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: AppDimens.h16),
                                      child: DateWidget(
                                        selectedDate:
                                            _foodRecord?.getCreatedAt(),
                                        listener: this,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.visibleAddIngredient,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: AppDimens.h16),
                                      child: IngredientWidget(
                                        ingredients:
                                            _foodRecord?.ingredients ?? [],
                                        listener: this,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppDimens.h16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ActionButtonsWidget(
                          logButtonText: widget.isUpdate ||
                                  widget.foodRecordIngredient != null
                              ? context.localization?.save
                              : context.localization?.log,
                          listener: this,
                        ),
                        SizedBox(height: AppDimens.h24),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.indigo600Main),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleStates({
    required BuildContext context,
    required EditFoodState state,
  }) {
    if (state is ConversionSuccessState) {
      _foodRecord = state.foodRecord;
      _sliderData = state.sliderData;
      _entityTypeName = _foodRecord?.entityType?.name ?? '';
    } else if (state is UpdateServingQuantitySuccessState) {
      _foodRecord = state.foodRecord;
      _sliderData = state.sliderData;
    } else if (state is LogSuccessState) {
      if (widget.redirectToDiaryOnLog) {
        DashboardPage.navigate(
          context,
          page: 1,
          removeUntil: true,
        );
        context.showSnackbar(text: context.localization?.itemAddedToDiary);
      } else {
        if (widget.message != null) {
          context.showSnackbar(text: widget.message);
        }
        Navigator.pop(context, true);
      }
    } else if (state is UpdateServingUnitSuccessState) {
      _foodRecord = state.foodRecord;
    } else if (state is ConversionFailureState) {
      context.showSnackbar(text: state.message);
    } else if (state is FavoriteChangeSuccessState) {
      if (state.isFavorite) {
        context.showSnackbar(text: context.localization?.addedToFavorites);
      } else {
        context.showSnackbar(text: context.localization?.removedFromFavorites);
      }
    } else if (state is LogDeleteSuccessState) {
      Navigator.pop(context, true);
    }
  }

  @override
  void onDateChanged(DateTime dateTime) {
    _bloc.add(DoUpdateDateEvent(dateTime: dateTime));
  }

  @override
  void onMealTimeChanged(MealLabel mealLabel) {
    _bloc.add(DoUpdateMealLabelEvent(mealLabel: mealLabel));
  }

  @override
  void onFavoriteChanged(bool isFavorite) {
    if (!isFavorite) {
      SingleTextFieldNewDialog.show(
          context: context,
          title: context.localization?.nameYourFavorite,
          placeHolder:
              '${context.localization?.my ?? ''} ${_foodRecord?.name ?? ''}',
          onSave: (value) {
            _bloc.add(DoFavoriteChangeEvent(name: value));
          });
    } else {
      _bloc.add(const DoFavoriteChangeEvent());
    }
  }

  @override
  void onServingQuantityChanged(double quantity, bool resetSlider) {
    _bloc.add(DoUpdateServingQuantityEvent(
        quantity: quantity, resetSlider: resetSlider));
  }

  @override
  Future<void> onAddIngredientRequested() async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FoodSearchPage(needsReturn: true),
      ),
    );

    if (data != null && data is PassioFoodDataInfo) {
      _bloc.add(DoAddIngredientEvent(searchResult: data));
    }
  }

  @override
  Future<void> onIngredientTapped(
      FoodRecordIngredient foodRecordIngredient) async {
    final index = _foodRecord?.ingredients.indexOf(foodRecordIngredient) ?? 0;

    final data = await EditFoodPage.navigate(
      context: context,
      foodRecordIngredient:
          FoodRecordIngredient.fromJson(foodRecordIngredient.toJson()),
      iconHeroTag: '${foodRecordIngredient.iconId}$index',
      needsReturn: true,
      visibleMealTimeView: false,
      visibleDateView: false,
      visibleAddIngredient: false,
      visibleFavorite: false,
    );
    if (data != null && data is FoodRecord) {
      _bloc.add(DoReplaceIngredientEvent(index: index, ingredient: data));
    }
  }

  @override
  void onIngredientDeleted(int index) {
    _bloc.add(DoRemoveIngredientEvent(index: index));
  }

  @override
  void onServingUnitChanged(String unit) {
    _bloc.add(DoUpdateServingUnitEvent(unit: unit));
  }

  @override
  void onLogTapped() {
    if (widget.needsReturn) {
      Navigator.pop(context, _foodRecord);
    } else {
      bool isNowRecipe = _foodRecord?.entityType == PassioIDEntityType.recipe &&
          _entityTypeName != _foodRecord?.entityType?.name;
      if (isNowRecipe) {
        CreateRecipeDialog.show(
          context: context,
          placeHolder: _foodRecord?.name,
          onCreateRecipe: (name) {
            _foodRecord?.name = name;
            _bloc.add(DoLogEvent(isUpdate: widget.isUpdate));
          },
        );
      } else {
        _bloc.add(DoLogEvent(isUpdate: widget.isUpdate));
      }
    }
  }

  @override
  void onCancelTapped() {
    Navigator.pop(context);
  }

  void onDeleteTapped() {
    _bloc.add(const DoDeleteLogEvent());
  }

  void onSwitchTapped() {
    FoodSearchPage.navigate(context).then((value) {
      if (value != null && value is PassioFoodDataInfo) {
        _bloc.add(DoConversionEvent(
          foodDataInfo: value,
        ));
      }
    });
  }

  @override
  void onMoreDetailsTapped() {
    NutritionInformationPage.navigate(
        context: context, foodRecord: _foodRecord);
  }

  @override
  void onOpenFoodFactsTapped() {
    OpenFoodFactsDialog.show(context: context);
  }
}
