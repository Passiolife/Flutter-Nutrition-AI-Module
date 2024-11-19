import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/models/food_record/food_record.dart';
import '../../../../common/util/context_extension.dart';
import 'bloc/recipe_creator_bloc.dart';
import 'widgets/widgets.dart';

class RecipeCreatorPage extends StatefulWidget {
  const RecipeCreatorPage({this.isUpdate = false, super.key});

  final bool isUpdate;

  static Future navigate({
    required BuildContext context,
    FoodRecord? foodRecord,
    bool isUpdate = false,
    bool navigateToCustomFoods = false,
    bool forceNavigateToCustomFoods = false,
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeCreatorPage(
          isUpdate: isUpdate,
            /*foodRecord: foodRecord,

          navigateToCustomFoods: navigateToCustomFoods,
          forceNavigateToCustomFoods: forceNavigateToCustomFoods,*/
            ),
      ),
    );
  }

  @override
  State<RecipeCreatorPage> createState() => _RecipeCreatorPageState();
}

class _RecipeCreatorPageState extends State<RecipeCreatorPage> {
  final _bloc = RecipeCreatorBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeCreatorBloc, RecipeCreatorState>(
      bloc: _bloc,
      listener: _handleStateChanges,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          body: Column(
            children: [
              CustomAppBarWidget(
                title: context.localization?.myFoods,
                isMenuVisible: false,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: context.keyboardHeight),
                    child: Column(
                      children: [
                        RecipeDetailsWidget(
                          onTapBarcode: () async {
                            /*_barcode = await BarcodeScannerPage.navigate(
                                context: context);
                            _bloc.add(DoUpdateBarcodeEvent(barcode: _barcode));*/
                          },
                          onChangeFoodDetails: (profile, name, brand) {
                            /*_bloc.add(DoUpdateFoodDetailsEvent(
                              image: profile,
                              name: name,
                              brand: brand,
                            ));*/
                          },
                        ),
                        16.verticalSpace,
                        /*RequiredNutritionFactsWidget(
                          initialServingSize:
                          widget.foodRecord?.getSelectedQuantity(),
                          initialUnit: widget.foodRecord?.getSelectedUnit(),
                          initialWeightValue: widget.foodRecord?.servingUnits
                              .firstOrNull?.weight.value,
                          initialWeightSymbol: widget.foodRecord?.servingUnits
                              .firstOrNull?.weight.symbol,
                          initialCalories: widget.foodRecord
                              ?.nutrientsSelectedSize()
                              .calories,
                          initialFat:
                          widget.foodRecord?.nutrientsSelectedSize().fat,
                          initialCarbs:
                          widget.foodRecord?.nutrientsSelectedSize().carbs,
                          initialProtein: widget.foodRecord
                              ?.nutrientsSelectedSize()
                              .proteins,
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
                          satFatValue: _satFat,
                          transFatValue: _transFat,
                          cholesterolValue: _cholesterol,
                          sodiumValue: _sodium,
                          dietaryFiberValue: _dietaryFiber,
                          totalSugarsValue: _totalSugars,
                          addedSugarValue: _addedSugar,
                          vitaminDValue: _vitaminD,
                          calciumValue: _calcium,
                          potassiumValue: _potassium,
                          onChanged: (value) {
                            final satFatNutrient = _getNutrient(
                                value, context.localization?.saturatedFat);
                            _satFat = satFatNutrient?.value ?? '';

                            final transFatNutrient = _getNutrient(
                                value, context.localization?.transFat);
                            _transFat = transFatNutrient?.value ?? '';

                            final cholesterolNutrient = _getNutrient(
                                value, context.localization?.cholesterol);
                            _cholesterol = cholesterolNutrient?.value ?? '';

                            final sodiumNutrient = _getNutrient(
                                value, context.localization?.sodium);
                            _sodium = sodiumNutrient?.value ?? '';

                            final dietaryFiberNutrient = _getNutrient(
                                value, context.localization?.dietaryFiber);
                            _dietaryFiber = dietaryFiberNutrient?.value ?? '';

                            final totalSugarsNutrient = _getNutrient(
                                value, context.localization?.totalSugars);
                            _totalSugars = totalSugarsNutrient?.value ?? '';

                            final addedSugarNutrient = _getNutrient(
                                value, context.localization?.addedSugar);
                            _addedSugar = addedSugarNutrient?.value ?? '';

                            final vitaminDNutrient = _getNutrient(
                                value, context.localization?.vitaminD);
                            _vitaminD = vitaminDNutrient?.value ?? '';

                            final calciumNutrient = _getNutrient(
                                value, context.localization?.calcium);
                            _calcium = calciumNutrient?.value ?? '';

                            final potassiumNutrient = _getNutrient(
                                value, context.localization?.potassium);
                            _potassium = potassiumNutrient?.value ?? '';

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
                          },
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
              /*Visibility(
                visible: context.keyboardHeight <= 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ActionButtonsWidget(
                    onNegativeButtonTap: () {
                      Navigator.pop(context);
                    },
                    onPositiveButtonTap: () {
                      _bloc.add(DoSaveEvent(
                        oldFoodRecord: widget.foodRecord,
                        isUpdate: widget.isUpdate,
                      ));
                    },
                    isPositiveButtonEnabled: _saveEnabled,
                  ),
                ),
              ),*/
              (context.bottomPadding + 8).verticalSpace,
            ],
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, RecipeCreatorState state) {
    // if (state is ListenerState) {
    //   switch (state) {
    //     case UpdateSaveListenerState():
    //       _saveEnabled = state.saveEnabled;
    //       break;
    //     case SaveSuccessState():
    //       if (widget.navigateToCustomFoods) {
    //         // Pop until CustomFoodsPage and then pop with data
    //         Navigator.popUntil(context, (route) {
    //           if (route.settings.name == '/customFoodsPage') {
    //             Navigator.pop(context, 'yourData'); // Pass your data here
    //             return true;
    //           }
    //           return false;
    //         });
    //         return;
    //       } else if (widget.forceNavigateToCustomFoods) {
    //         MyFoodsPage.navigate(context: context, isReplace: true);
    //         return;
    //       }
    //       Navigator.pop(context, true);
    //       break;
    //     case SaveFailureState():
    //       context.showSnackbar(text: state.message);
    //       break;
    //   }
    // }
  }
}
