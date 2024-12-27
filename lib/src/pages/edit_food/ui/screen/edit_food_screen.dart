

part of '../edit_food_page.dart';

class EditFoodScreen extends StatefulWidget {
  const EditFoodScreen({super.key});

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen>
    implements EditFoodListener, FoodHeaderListener {
  late final _bloc = context.read<EditFoodBloc>();

  FoodRecord? _foodRecord;

  SliderData? _sliderData;

  String _entityTypeName = '';

  bool get _isOpenFood =>
      _foodRecord?.openFoodLicense != null ||
      (_foodRecord?.ingredients
              .any((element) => element.openFoodLicense != null) ??
          false);

  bool get isRecipe => (_foodRecord?.ingredients.length ?? 0) > 1;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final foodItem = NavigationDataProvider.of(context).params.foodItem;
      final foodRecordIngredient =
          NavigationDataProvider.of(context).params.foodRecordIngredient;
      final foodRecord = NavigationDataProvider.of(context).params.foodRecord;
      final detectedCandidate =
          NavigationDataProvider.of(context).params.detectedCandidate;
      final searchResult =
          NavigationDataProvider.of(context).params.passioFoodDataInfo;
      final mealLabel = NavigationDataProvider.of(context).params.mealLabel;
      final shouldUpdateServingUnit =
          NavigationDataProvider.of(context).params.shouldUpdateServingUnit;
      _bloc.add(DoConversionEvent(
        foodItem: foodItem,
        foodRecordIngredient: foodRecordIngredient,
        foodRecord: foodRecord,
        detectedCandidate: detectedCandidate,
        foodDataInfo: searchResult,
        mealLabel: mealLabel,
        shouldUpdateServingUnit: shouldUpdateServingUnit,
      ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final visibleFoodHeaderView =
        NavigationDataProvider.of(context).params.visibleFoodHeaderView;

    final iconHeroTag = NavigationDataProvider.of(context).params.iconHeroTag;
    final visibleOpenFoodFacts =
        NavigationDataProvider.of(context).params.visibleOpenFoodFacts;
    final visibleMoreDetails =
        NavigationDataProvider.of(context).params.visibleMoreDetails;
    final visibleFavorite =
        NavigationDataProvider.of(context).params.visibleFavorite;
    final visibleServingSizeView =
        NavigationDataProvider.of(context).params.visibleServingSizeView;
    final visibleMealTimeView =
        NavigationDataProvider.of(context).params.visibleMealTimeView;
    final visibleDateView =
        NavigationDataProvider.of(context).params.visibleDateView;
    final visibleAddIngredient =
        NavigationDataProvider.of(context).params.visibleAddIngredient;
    final positiveButtonText =
        NavigationDataProvider.of(context).params.positiveButtonText;
    final visibleDelete =
        NavigationDataProvider.of(context).params.visibleDelete;
    final isUpdate = NavigationDataProvider.of(context).params.isUpdate;
    final foodRecordIngredient =
        NavigationDataProvider.of(context).params.foodRecordIngredient;
    final needsReturn = NavigationDataProvider.of(context).params.needsReturn;

    return BlocConsumer<EditFoodBloc, EditFoodState>(
      bloc: context.read<EditFoodBloc>(),
      listener: (context, state) {
        _handleStates(context: context, state: state);
      },
      buildWhen: (_, state) {
        return state is! UserFoodFlowState;
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              const TitleSection(),
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
                                    visible: visibleFoodHeaderView,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: AppDimens.h16),
                                      child: FoodHeaderWidget(
                                        foodRecord: _foodRecord,
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
                                        iconHeroTag: iconHeroTag,
                                        visibleOpenFoodFacts:
                                            visibleOpenFoodFacts ?? _isOpenFood,
                                        visibleMoreDetails: visibleMoreDetails,
                                        visibleFavorite: visibleFavorite,
                                        listener: this,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visibleServingSizeView,
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
                                  MealTimeSection(
                                    visibleMealTimeView: visibleMealTimeView,
                                    mealLabel: _foodRecord?.mealLabel,
                                  ),
                                  Visibility(
                                    visible: visibleDateView,
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
                                  IngredientsSection(
                                    visibleAddIngredient: visibleAddIngredient,
                                  ),
                                  SizedBox(height: AppDimens.h16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ActionButtonSection(
                          positiveButtonText: positiveButtonText,
                          visibleDelete: visibleDelete,
                          isUpdate: isUpdate || foodRecordIngredient != null,
                          needsReturn: needsReturn,
                          foodRecord: _foodRecord,
                          entityTypeName: _entityTypeName,
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

  Future<void> _handleStates({
    required BuildContext context,
    required EditFoodState state,
  }) async {
    final redirectToDiaryOnLog =
        NavigationDataProvider.of(context).params.redirectToDiaryOnLog;
    final message = NavigationDataProvider.of(context).params.message;
    final source = NavigationDataProvider.of(context).params.source;
    final visibleLogUponCreate =
        NavigationDataProvider.of(context).params.visibleLogUponCreate;

    if (state is ConversionSuccessState) {
      _foodRecord = state.foodRecord;
      _sliderData = state.sliderData;
      _entityTypeName = _foodRecord?.entityType?.name ?? '';
    } else if (state is UpdateServingQuantitySuccessState) {
      _foodRecord = state.foodRecord;
      _sliderData = state.sliderData;
    } else if (state is LogSuccessState) {
      if (redirectToDiaryOnLog) {
        DashboardPage.navigate(
          context,
          page: 1,
          removeUntil: true,
        );
        context.showSnackbar(text: context.localization?.itemAddedToDiary);
      } else {
        if (message != null) {
          context.showSnackbar(text: message);
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

    // States for User food creation.
    else if (state is UserFoodFetchSuccessState) {
      await FoodCreatorPage.navigate(
        context: context,
        userFoodRecord: state.userFoodRecord,
        loggedFoodRecord: _foodRecord,
        logUponCreate: state.logUpdateOnCreate,
      );
    } else if (state is UserFoodFetchFailureState) {
      UserFoodNotFoundDialog.show(
        context: context,
        foodRecord: _foodRecord,
        logUpdateOnCreate: state.logUpdateOnCreate,
      );
    } else if (state is UserFoodFlowState) {
      if (source == AppCommonConstants.userFood) {
        await FoodCreatorPage.navigate(
          context: context,
          userFoodRecord: _foodRecord,
        );
        return;
      }
      CreateUserFoodDialog.show(
        context: context,
        isLogUpdateVisibleOnCreate:
            visibleLogUponCreate ?? _foodRecord?.id.isNotEmpty ?? false,
        foodRecord: _foodRecord,
        onEdit: (sfContext, logUpdateOnCreate) {
          _bloc.add(DoFetchUserCreatedFoodEvent(
              foodRecord: _foodRecord, logUpdateOnCreate: logUpdateOnCreate));
        },
      );
    }

    // States for User recipe creation.
    else if (state is UserRecipeFetchSuccessState) {
      await RecipeCreatorPage.navigate(
        context: context,
        params: NavigationData(
          logUponCreate: state.logUpdateOnCreate,
          loggedFoodRecord: _foodRecord,
          recipeFoodRecord: state.userRecipeRecord
        ),
      );
    } else if (state is UserRecipeFetchFailureState) {
      UserRecipeNotFoundDialog.show(
        context: context,
        foodRecord: _foodRecord,
        logUpdateOnCreate: state.logUpdateOnCreate,
      );
    }
  }

  @override
  void onDateChanged(DateTime dateTime) {
    _bloc.add(DoUpdateDateEvent(dateTime: dateTime));
  }

  @override
  void onFavoriteChanged(bool isFavorite) {
    _bloc.add(const DoFavoriteChangeEvent());
    return;
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
      params: EditFoodPageParams(
        foodRecordIngredient:
            FoodRecordIngredient.fromJson(foodRecordIngredient.toJson()),
        iconHeroTag: '${foodRecordIngredient.iconId}$index',
        needsReturn: true,
        visibleMealTimeView: false,
        visibleDateView: false,
        visibleAddIngredient: false,
        visibleFavorite: false,
      ),
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
  void onMoreDetailsTapped() {
    NutritionInformationPage.navigate(
      context: context,
      foodRecord: _foodRecord,
    );
  }

  @override
  void onOpenFoodFactsTapped() {
    OpenFoodFactsDialog.show(context: context);
  }
}
