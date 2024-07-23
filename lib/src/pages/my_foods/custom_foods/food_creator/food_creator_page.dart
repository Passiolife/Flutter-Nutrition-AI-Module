import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/constant/app_colors.dart';
import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/context_extension.dart';
import '../../../../common/util/double_extensions.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../../../../common/util/string_extensions.dart';
import '../../my_foods_page.dart';
import 'barcode_scanner/barcode_scanner_page.dart';
import 'bloc/food_creator_bloc.dart';
import 'models/nutrient.dart';
import 'widgets/widgets.dart';

class FoodCreatorPage extends StatefulWidget {
  const FoodCreatorPage({
    this.foodRecord,
    this.isUpdate = false,
    this.navigateToCustomFoods = false,
    this.forceNavigateToCustomFoods = false,
    super.key,
  });

  final FoodRecord? foodRecord;
  final bool isUpdate;
  final bool navigateToCustomFoods;
  final bool forceNavigateToCustomFoods;

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
        builder: (_) => FoodCreatorPage(
          foodRecord: foodRecord,
          isUpdate: isUpdate,
          navigateToCustomFoods: navigateToCustomFoods,
          forceNavigateToCustomFoods: forceNavigateToCustomFoods,
        ),
      ),
    );
  }

  @override
  State<FoodCreatorPage> createState() => _FoodCreatorPageState();
}

class _FoodCreatorPageState extends State<FoodCreatorPage> {
  bool _saveEnabled = false;

  final _bloc = FoodCreatorBloc();

  String? _barcode;
  String _satFat = '';
  String _transFat = '';
  String _cholesterol = '';
  String _sodium = '';
  String _dietaryFiber = '';
  String _totalSugars = '';
  String _addedSugar = '';
  String _vitaminD = '';
  String _calcium = '';
  String _potassium = '';

  Uint8List? image;

  @override
  void initState() {
    _satFat = widget.foodRecord?.nutrients().satFat?.value.format() ?? '';
    _transFat = widget.foodRecord?.nutrients().transFat?.value.format() ?? '';
    _cholesterol =
        widget.foodRecord?.nutrients().cholesterol?.value.format() ?? '';
    _sodium = widget.foodRecord?.nutrients().sodium?.value.format() ?? '';
    _dietaryFiber = widget.foodRecord?.nutrients().fibers?.value.format() ?? '';
    _totalSugars = widget.foodRecord?.nutrients().sugars?.value.format() ?? '';
    _addedSugar =
        widget.foodRecord?.nutrients().sugarsAdded?.value.format() ?? '';
    _vitaminD = widget.foodRecord?.nutrients().vitaminD?.value.format() ?? '';
    _calcium = widget.foodRecord?.nutrients().calcium?.value.format() ?? '';
    _potassium = widget.foodRecord?.nutrients().potassium?.value.format() ?? '';

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _barcode = widget.foodRecord?.barcode;
      _bloc.add(DoUpdateBarcodeEvent(barcode: _barcode));
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
                        FoodDetailsWidget(
                          key: ValueKey(_barcode),
                          initialIconId: widget.foodRecord?.iconId,
                          initialName: widget.foodRecord?.name.toUpperCaseWord,
                          initialBrand: widget.foodRecord?.additionalData.toUpperCaseWord,
                          initialBarcode: _barcode,
                          onTapBarcode: () async {
                            _barcode = await BarcodeScannerPage.navigate(
                                context: context);
                            _bloc.add(DoUpdateBarcodeEvent(barcode: _barcode));
                          },
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
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
              ),
              (context.bottomPadding + 8).verticalSpace,
            ],
          ),
        );
      },
    );
  }

  Nutrient? _getNutrient(List<Nutrient> value, String? label) {
    return value
        .cast<Nutrient?>()
        .firstWhere((e) => e?.label == label, orElse: () => null);
  }

  void _handleStateChanges(BuildContext context, FoodCreatorState state) {
    if (state is ListenerState) {
      switch (state) {
        case UpdateSaveListenerState():
          _saveEnabled = state.saveEnabled;
          break;
        case SaveSuccessState():
          if (widget.navigateToCustomFoods) {
            // Pop until CustomFoodsPage and then pop with data
            Navigator.popUntil(context, (route) {
              if (route.settings.name == '/customFoodsPage') {
                Navigator.pop(context, 'yourData'); // Pass your data here
                return true;
              }
              return false;
            });
            return;
          } else if (widget.forceNavigateToCustomFoods) {
            MyFoodsPage.navigate(context: context, isReplace: true);
            return;
          }
          Navigator.pop(context, true);
          break;
        case SaveFailureState():
          context.showSnackbar(text: state.message);
          break;
      }
    }
  }
}
