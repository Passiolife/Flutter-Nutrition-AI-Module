import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/constant/app_colors.dart';
import '../../../../common/constant/app_constants.dart';
import '../../../../common/router/routes.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../../../../common/extension/string_extensions.dart';
import '../../../barcode_scanner/barcode_scanner_page.dart';
import '../../../dashboard/dashboard_page.dart';
import '../../my_foods_page.dart';
import 'bloc/food_creator_bloc.dart';
import 'view_models/food_creator_view_model.dart';
import 'view_models/nutrient_view_model.dart';
import 'widgets/widgets.dart';

class FoodCreatorPage extends StatefulWidget {
  const FoodCreatorPage({
    this.loggedFoodRecord,
    this.userFoodRecord,
    this.nutritionFacts,
    required this.logUponCreate,
    super.key,
  });

  final FoodRecord? loggedFoodRecord;
  final FoodRecord? userFoodRecord;
  final PassioNutritionFacts? nutritionFacts;
  final bool logUponCreate;

  static MaterialPageRoute route({
    FoodRecord? loggedFoodRecord,
    FoodRecord? userFoodRecord,
    PassioNutritionFacts? nutritionFacts,
    bool logUponCreate = false,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.foodCreator),
      builder: (_) => FoodCreatorPage(
        loggedFoodRecord: loggedFoodRecord,
        userFoodRecord: userFoodRecord,
        nutritionFacts: nutritionFacts,
        logUponCreate: logUponCreate,
      ),
    );
  }

  static Future navigate({
    required BuildContext context,
    FoodRecord? loggedFoodRecord,
    FoodRecord? userFoodRecord,
    PassioNutritionFacts? nutritionFacts,
    bool logUponCreate = false,
  }) async {
    return await Navigator.pushNamed(
      context,
      Routes.foodCreator,
      arguments: [
        loggedFoodRecord,
        userFoodRecord,
        nutritionFacts,
        logUponCreate,
      ],
    );
  }

  @override
  State<FoodCreatorPage> createState() => _FoodCreatorPageState();
}

class _FoodCreatorPageState extends State<FoodCreatorPage> {
  bool _saveEnabled = false;

  final _bloc = FoodCreatorBloc();

  FoodCreatorViewModel? _foodCreatorViewModel;

  ValueKey _refreshKey = ValueKey(null);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc.add(DoConversionEvent(
        loggedFoodRecord: widget.loggedFoodRecord,
        userFoodRecord: widget.userFoodRecord,
        nutritionFacts: widget.nutritionFacts,
        logUponCreate: widget.logUponCreate,
      ));
    });
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodCreatorBloc, FoodCreatorState>(
      bloc: _bloc,
      listener: _handleStateChanges,
      builder: (bContext, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          body: Column(
            children: [
              CustomAppBarWidget(
                title: context.localization.myFoods,
                isMenuVisible: false,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: SingleChildScrollView(
                    padding: context.keyboardHeight,
                    child: Column(
                      key: _refreshKey,
                      children: [
                        FoodDetailsWidget(
                          initialImage: _foodCreatorViewModel?.image,
                          initialIconId: _foodCreatorViewModel?.iconId,
                          initialName:
                              _foodCreatorViewModel?.name.toUpperCaseWord,
                          initialBrand: _foodCreatorViewModel
                              ?.additionalData.toUpperCaseWord,
                          initialBarcode: _foodCreatorViewModel?.barcode,
                          onTapBarcode: _onTapBarcode,
                          onChangeFoodDetails: (profile, name, brand) {
                            _bloc.add(DoUpdateFoodDetailsEvent(
                              image: profile,
                              name: name,
                              brand: brand,
                            ));
                          },
                        ),
                        16.verticalSpace,
                        RequiredNutritionFactsWidget(
                          initialServingSize:
                              _foodCreatorViewModel?.servingQuantity,
                          initialUnit: _foodCreatorViewModel?.servingUnit,
                          initialWeightValue:
                              _foodCreatorViewModel?.weightValue,
                          initialWeightSymbol:
                              _foodCreatorViewModel?.weightSymbol,
                          initialCalories: _foodCreatorViewModel?.calories,
                          initialFat: _foodCreatorViewModel?.fat,
                          initialCarbs: _foodCreatorViewModel?.carbs,
                          initialProtein: _foodCreatorViewModel?.protein,
                          onChange: (servingSize, unit, weightValue,
                              weightSymbol, calories, fat, carbs, protein) {
                            _bloc.add(DoUpdateRequiredNutritionFactsEvent(
                              servingQuantity: servingSize,
                              servingUnit: unit,
                              weightValue: weightValue,
                              weightSymbol: weightSymbol,
                              calories: calories,
                              fat: fat,
                              carbs: carbs,
                              protein: protein,
                            ));
                          },
                        ),
                        16.verticalSpace,
                        OtherNutritionFactsWidget(
                          viewModel: _foodCreatorViewModel,
                          onChanged: _handleChangedOtherNutrients,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: context.keyboardHeightValue <= 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ActionButtonsWidget(
                    onNegativeButtonTap: () {
                      Navigator.pop(context);
                    },
                    onPositiveButtonTap: () {
                      _bloc.add(DoSaveEvent());
                    },
                    isPositiveButtonEnabled: _saveEnabled,
                  ),
                ),
              ),
              (context.bottomPaddingValue + 8).verticalSpace,
            ],
          ),
        );
      },
    );
  }

  void _handleChangedOtherNutrients(List<NutrientViewModel> nutrients) {
    final satFatNutrient =
        _getNutrient(nutrients, context.localization.saturatedFat);

    final transFatNutrient =
        _getNutrient(nutrients, context.localization.transFat);

    final cholesterolNutrient =
        _getNutrient(nutrients, context.localization.cholesterol);

    final sodiumNutrient =
        _getNutrient(nutrients, context.localization.sodium);

    final dietaryFiberNutrient =
        _getNutrient(nutrients, context.localization.dietaryFiber);

    final totalSugarsNutrient =
        _getNutrient(nutrients, context.localization.totalSugars);

    final addedSugarNutrient =
        _getNutrient(nutrients, context.localization.addedSugar);

    final vitaminDNutrient =
        _getNutrient(nutrients, context.localization.vitaminD);

    final calciumNutrient =
        _getNutrient(nutrients, context.localization.calcium);

    final potassiumNutrient =
        _getNutrient(nutrients, context.localization.potassium);

    _bloc.add(DoUpdateOtherNutritionFactsEvent(
      satFat: satFatNutrient,
      transFat: transFatNutrient,
      cholesterol: cholesterolNutrient,
      sodium: sodiumNutrient,
      dietaryFiber: dietaryFiberNutrient,
      totalSugars: totalSugarsNutrient,
      addedSugars: addedSugarNutrient,
      vitaminD: vitaminDNutrient,
      calcium: calciumNutrient,
      potassium: potassiumNutrient,
    ));
  }

  NutrientViewModel? _getNutrient(
      List<NutrientViewModel> value, String? label) {
    return value
        .cast<NutrientViewModel?>()
        .firstWhere((e) => e?.label == label, orElse: () => null);
  }

  Future<void> _onTapBarcode() async {
    final navigationResult = await BarcodeScannerPage.navigate(context: context);
    if(navigationResult == null) {
      return;
    }
    if(navigationResult is String) {
      _bloc.add(DoUpdateBarcodeEvent(barcode: navigationResult));
    } else if(navigationResult is FoodRecord?) {
      _bloc.add(DoConversionEvent(
        loggedFoodRecord: widget.loggedFoodRecord,
        userFoodRecord: navigationResult,
        nutritionFacts: widget.nutritionFacts,
        logUponCreate: widget.logUponCreate,
      ));
    }
  }

  void _handleStateChanges(BuildContext context, FoodCreatorState state) {
    if (state is ListenerState) {
      switch (state) {
        case SaveSuccessState():
          if (widget.logUponCreate) {
            context.showSnackbar(
                text: widget.userFoodRecord == null
                    ? context.localization.customFoodCreatedWithUpdateSuccess
                    : context.localization.customFoodUpdatedWithUpdateSuccess);
            DashboardPage.navigate(
              context,
              page: 1,
              removeUntil: true,
            );
          } else {
            context.showSnackbar(
                text: widget.userFoodRecord == null
                    ? context.localization.customFoodCreatedWithSuccess
                    : context.localization.customFoodUpdatedWithSuccess);
            MyFoodsPage.navigate(context: context, isReplace: true);
          }
          break;
        case SaveFailureState():
          context.showSnackbar(text: state.message);
          break;
        case ConversionSuccessListenerState():
          _foodCreatorViewModel = state.viewModel;
          _saveEnabled = state.saveEnabled;
          _refreshKey = ValueKey(_foodCreatorViewModel);
          break;
        case UpdateFoodDetailsSuccessListenerState():
          _foodCreatorViewModel = state.viewModel;
          _saveEnabled = state.saveEnabled;
          break;
        case UpdateBarcodeSuccessListenerState():
          _foodCreatorViewModel = state.viewModel;
          _saveEnabled = state.saveEnabled;
          _refreshKey = ValueKey(_foodCreatorViewModel);
          break;
        case UpdateRequiredNutritionFactsSuccessListenerState():
          _foodCreatorViewModel = state.viewModel;
          _saveEnabled = state.saveEnabled;
          break;
        case UpdateOtherNutritionFactsSuccessListenerState():
          _foodCreatorViewModel = state.viewModel;
          _saveEnabled = state.saveEnabled;
          break;
      }
    }
  }
}
