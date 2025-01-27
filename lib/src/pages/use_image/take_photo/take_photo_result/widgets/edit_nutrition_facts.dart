import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/extension/number_extension.dart';
import '../../../../../common/extension/string_extensions.dart';
import '../../../../../common/formatter/single_decimal_formatter.dart';
import '../../../../../common/models/key_value_model.dart';
import '../../../../../common/util/navigation_utils/hero_dialog_route.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/button/secondary_button.dart';
import '../../../../../common/widgets/drop_down/secondary_dropdown.dart';
import '../../../../../common/widgets/icons/barcode_scan_widget.dart';
import '../../../../../common/widgets/text_input/number_text_input.dart';
import '../../../../../common/widgets/text_input/primary_text_input.dart';
import '../../../../barcode_scanner/barcode_scanner_page.dart';

class EditNutritionFacts extends StatefulWidget {
  const EditNutritionFacts({
    required this.foodRecord,
    required this.index,
    required this.showMissing,
    super.key,
  });

  final FoodRecord foodRecord;
  final int? index;
  final bool showMissing;

  static Future<FoodRecord?> navigate({
    required BuildContext context,
    required FoodRecord foodRecord,
    int? index,
    bool showMissing = false,
  }) {
    return Navigator.push(
      context,
      HeroDialogRoute(
        child: EditNutritionFacts(
          foodRecord: foodRecord,
          index: index,
          showMissing: showMissing,
        ),
      ),
    );
  }

  @override
  State<EditNutritionFacts> createState() => _EditNutritionFactsState();
}

class _EditNutritionFactsState extends State<EditNutritionFacts> {
  late FoodRecord _foodRecord;

  final _formKey = GlobalKey<FormState>();

  String? _name;
  double? _quantity;
  String? _unit;
  double? _weight;
  double? _calories;
  double? _carbs;
  double? _protein;
  double? _fat;
  String? _barcode;

  @override
  void initState() {
    super.initState();
    _foodRecord = widget.foodRecord.clone();
    _name = _foodRecord.name;
    _barcode = _foodRecord.barcode;
    _calories = _foodRecord.totalCalories;
    _carbs = _foodRecord.totalCarbs;
    _protein = _foodRecord.totalProteins;
    _fat = _foodRecord.totalFat;

    _quantity = _foodRecord.getSelectedQuantity();
    _weight = _foodRecord.computedWeight.value;
    _unit = _foodRecord.getSelectedUnit();

    SchedulerBinding.instance.addPostFrameCallback((_){
      _formKey.currentState?.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.transparent,
        child: Wrap(
          children: [
            Container(
              decoration: AppShadows.base,
              padding: AppPadding.pa16,
              margin: AppPadding.pa16 + context.keyboardHeight,
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 16.h,
                  children: [
                    Text(
                      context.localization.editNutritionFacts ?? '',
                      style: AppTextStyle.textXl.addAll([
                        AppTextStyle.textXl.leading7,
                        AppTextStyle.bold,
                      ]),
                    ),
                    _DetailsWidget(
                      index: widget.index,
                      foodRecord: _foodRecord,
                      onChange: (name, barcode) {
                        _name = name;
                        _barcode = barcode;
                      },
                    ),
                    _NutritionFactsWidget(
                      index: widget.index,
                      foodRecord: _foodRecord,
                      onChange: (calories, carbs, protein, fat) {
                        _calories = calories;
                        _carbs = carbs;
                        _protein = protein;
                        _fat = fat;
                      },
                    ),
                    _PortionsWidget(
                      foodRecord: _foodRecord,
                      onChange: (serving, weight, unit) {
                        _quantity = serving;
                        _weight = weight;
                        _unit = unit;
                      },
                    ),
                    _ActionButtons(
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onNext: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          Navigator.pop(context, toFoodRecord());
                          // Navigator.pop(context, toFoodRecord(_name, quantity, unit, weight, calories, carbs, protein, fat, barcode));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FoodRecord toFoodRecord(
      /*String name,
    double quantity,
    String unit,
    double weight,
    double calories,
    double carbs,
    double protein,
    double fat,
    String? barcode,*/
      ) {
    // Create a list of serving sizes with a default serving unit if not provided
    final servingSizes = _foodRecord.servingSizes;

    /*double servingWeightValue;
    // Create a serving weight with a default value of 100 grams if not provided
    if (servingUnit!.toLowerCase() != 'gram' &&
        servingUnit!.toLowerCase() != 'ml') {
      servingWeightValue = weightValue! / servingQuantity!;
    } else {
      servingWeightValue = 1;
    }*/

    UnitMass servingWeight = UnitMass(
      _weight!,
      UnitMassType.grams,
    );

    // Create a list of serving units with the serving weight and a default serving unit if not provided
    List<PassioServingUnit> servingUnits = _foodRecord.servingUnits;
    final index = servingUnits.indexWhere((e) => e.unitName == _unit);
    if (index != -1) {
      final selectedServingUnit = servingUnits[index];
      final newServingUnit = PassioServingUnit(
          _unit!, UnitMass(_weight!, selectedServingUnit.weight.unit));
      servingUnits[index] = newServingUnit;
    }

    // Create a food amount object with the selected quantity, unit, serving sizes, and serving units
    final amount = PassioFoodAmount(
      selectedQuantity: _quantity!,
      selectedUnit: _unit!,
      servingSizes: servingSizes,
      servingUnits: servingUnits,
    );

    // Create a food metadata object with the barcode
    final metadata = PassioFoodMetadata(barcode: _barcode);

    final referenceNutrients = PassioNutrients.fromNutrients(
      weight: servingWeight,
      calories: UnitEnergy(_calories!, UnitEnergyType.kilocalories),
      fat: UnitMass(_fat!, UnitMassType.grams),
      carbs: UnitMass(_carbs!, UnitMassType.grams),
      proteins: UnitMass(_protein!, UnitMassType.grams),
    );

    final passioId = _foodRecord.passioID;

    // Create an ingredient object with the amount, metadata, name, and reference nutrients
    final ingredient = PassioIngredient(
      amount: amount,
      iconId: _foodRecord.iconId,
      id: passioId,
      metadata: metadata,
      name: _name!,
      refCode: _foodRecord.refCode,
      referenceNutrients: referenceNutrients,
    );

    //   // Create a food record ingredient from the Passio ingredient and add additional data
    final foodRecordIngredient =
        FoodRecordIngredient.fromPassioIngredient(ingredient);
    foodRecordIngredient.id = _foodRecord.id;
    foodRecordIngredient.additionalData = _foodRecord.additionalData;

    // Create a food record from the food record ingredient
    final foodRecord =
        FoodRecord.fromFoodRecordIngredient(foodRecordIngredient);

    return foodRecord;
  }
}

class _DetailsWidget extends StatefulWidget {
  const _DetailsWidget({
    required this.index,
    required this.foodRecord,
    this.onChange,
  });

  final int? index;
  final FoodRecord foodRecord;
  final Function(String, String?)? onChange;

  @override
  State<_DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<_DetailsWidget> {
  String? _barcode;
  final _nameController = TextEditingController();

  @override
  void initState() {
    _barcode = widget.foodRecord.barcode;
    _nameController.text = widget.foodRecord.name;
    _nameController.addListener(() {
      widget.onChange?.call(_nameController.text, _barcode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PassioImageWidget(
          iconId: widget.foodRecord.iconId,
          radius: 20.r,
          heroTag: '${widget.foodRecord.iconId} ${widget.index}',
        ),
        8.horizontalSpace,
        Expanded(
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextInput(
                isDense: true,
                hintText: context.localization.enterName.toUpperCaseWord,
                controller: _nameController,
                // Disable the error text by setting empty error style
                errorStyle: TextStyle(height: 0.01),
                validator: (value) {
                  return value.isNotNullOrEmpty ? null : '';
                },
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),
              PrimaryTextInput(
                key: ValueKey(_barcode),
                isDense: true,
                hintText:
                    context.localization.enterBarcode.toUpperCaseWord ?? '',
                initialValue: _barcode,
                readOnly: true,
                suffix: UnconstrainedBox(
                  child: BarcodeScanWidget(),
                ),
                onTap: () async {
                  // String? barcode =
                  //     await BarcodeScannerPage.navigate(context: context);
                  // if (barcode?.isNotEmpty ?? false) {
                  //   setState(() {
                  //     _barcode = barcode;
                  //   });
                  //   widget.onChange?.call(_nameController.text, _barcode);
                  // }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NutritionFactsWidget extends StatefulWidget {
  const _NutritionFactsWidget({
    required this.index,
    required this.foodRecord,
    required this.onChange,
  });

  final int? index;
  final FoodRecord foodRecord;

  final Function(double?, double?, double?, double?) onChange;

  @override
  State<_NutritionFactsWidget> createState() => _NutritionFactsWidgetState();
}

class _NutritionFactsWidgetState extends State<_NutritionFactsWidget> {
  late TextEditingController _caloriesController;
  late TextEditingController _carbsController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;

  @override
  void initState() {
    _caloriesController =
        TextEditingController(text: widget.foodRecord.totalCalories.format());
    _carbsController =
        TextEditingController(/*text: widget.foodRecord.totalCarbs.format()*/);
    _proteinController =
        TextEditingController(text: widget.foodRecord.totalProteins.format());
    _fatController =
        TextEditingController(text: widget.foodRecord.totalFat.format());
    super.initState();
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.nutritionFacts ?? '',
          style: AppTextStyle.textBase
              .addAll([AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
        ),
        Row(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField(
              context: context,
              title: context.localization.calories ?? '',
              controller: _caloriesController,
              unit: context.localization.cal,
              onFieldSubmitted: (_) {
                widget.onChange.call(
                  double.tryParse(_caloriesController.text),
                  double.tryParse(_carbsController.text),
                  double.tryParse(_proteinController.text),
                  double.tryParse(_fatController.text),
                );
              },
            ),
            _buildField(
              context: context,
              title: context.localization.carbs ?? '',
              controller: _carbsController,
              onFieldSubmitted: (_) {
                widget.onChange.call(
                  double.tryParse(_caloriesController.text),
                  double.tryParse(_carbsController.text),
                  double.tryParse(_proteinController.text),
                  double.tryParse(_fatController.text),
                );
              },
            ),
            _buildField(
              context: context,
              title: context.localization.protein ?? '',
              controller: _proteinController,
              onFieldSubmitted: (_) {
                widget.onChange.call(
                  double.tryParse(_caloriesController.text),
                  double.tryParse(_carbsController.text),
                  double.tryParse(_proteinController.text),
                  double.tryParse(_fatController.text),
                );
              },
            ),
            _buildField(
              context: context,
              title: context.localization.fat ?? '',
              controller: _fatController,
              onFieldSubmitted: (_) {
                widget.onChange.call(
                  double.tryParse(_caloriesController.text),
                  double.tryParse(_carbsController.text),
                  double.tryParse(_proteinController.text),
                  double.tryParse(_fatController.text),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField({
    required BuildContext context,
    required String title,
    String? unit,
    TextEditingController? controller,
    Function(String)? onFieldSubmitted,
  }) {
    return Expanded(
      child: Column(
        spacing: 8.w,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyle.textSm.addAll(
                [AppTextStyle.textSm.leading4, AppTextStyle.medium]).copyWith(
              color: context.textThemeColors.brandTextLight,
            ),
          ),
          NumberTextInput(
            isDense: true,
            hintText: '',
            contentPadding: AppPadding.pv8,
            textAlign: TextAlign.center,
            controller: controller,
            errorStyle: TextStyle(height: 0.01),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return value.isNotNullOrEmpty ? null : '';
            },
            inputFormatters: [
              const SingleDecimalFormatter(),
            ],
            onFieldSubmitted: onFieldSubmitted,
            // suffix: Text(
            //   unit ?? '',
            //   style: AppTextStyle.textSm.addAll(
            //       [AppTextStyle.textSm.leading4, AppTextStyle.medium]).copyWith(
            //     color: context.textThemeColors.brandTextLight,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}

class _PortionsWidget extends StatefulWidget {
  const _PortionsWidget({
    required this.foodRecord,
    this.onChange,
  });

  final FoodRecord foodRecord;
  final Function(double?, double?, String)? onChange;

  @override
  State<_PortionsWidget> createState() => _PortionsWidgetState();
}

class _PortionsWidgetState extends State<_PortionsWidget> {
  late TextEditingController _servingController;
  late TextEditingController _weightController;

  late List<String> _units;
  late String _unit;

  @override
  void initState() {
    _servingController = TextEditingController(
        text: widget.foodRecord.getSelectedQuantity().format());
    _weightController = TextEditingController(
        text: widget.foodRecord.computedWeight.value.format());
    _units = widget.foodRecord.servingUnits.map((e) => e.unitName).toList();
    _unit = widget.foodRecord.getSelectedUnit();
    super.initState();
  }

  @override
  void dispose() {
    _servingController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.portions ?? '',
          style: AppTextStyle.textBase
              .addAll([AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
        ),
        Row(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField(
              context: context,
              title: context.localization.serving.toUpperCaseWord,
              controller: _servingController,
              onFieldSubmitted: (_) {
                widget.onChange?.call(
                  double.tryParse(_servingController.text),
                  double.tryParse(_weightController.text),
                  _unit,
                );
              },
              // unit: context.localization.cal
            ),
            _buildField(
              context: context,
              title: context.localization.weight ?? '',
              controller: _weightController,
              onFieldSubmitted: (_) {
                widget.onChange?.call(
                  double.tryParse(_servingController.text),
                  double.tryParse(_weightController.text),
                  _unit,
                );
              },
            ),
            Expanded(
              flex: 3,
              child: Column(
                spacing: 8.w,
                children: [
                  Text(
                    context.localization.unit ?? '',
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading4,
                      AppTextStyle.medium
                    ]).copyWith(
                      color: context.textThemeColors.brandTextLight,
                    ),
                  ),
                  SecondaryDropdown<String>(
                    height: 40.h,
                    value: KeyValueModel(
                        text: _unit.toUpperCaseWord, value: _unit),
                    options: _units.map((e) {
                      return KeyValueModel(value: e, text: e.toUpperCaseWord);
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        setState(() {
                          _unit = value.value;
                        });
                        widget.onChange?.call(
                          double.tryParse(_servingController.text),
                          double.tryParse(_weightController.text),
                          _unit,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField({
    required BuildContext context,
    required String title,
    int flex = 1,
    String? suffix,
    TextEditingController? controller,
    Function(String)? onFieldSubmitted,
  }) {
    return Expanded(
      flex: flex,
      child: Column(
        spacing: 8.w,
        children: [
          Text(
            title,
            style: AppTextStyle.textSm.addAll(
                [AppTextStyle.textSm.leading4, AppTextStyle.medium]).copyWith(
              color: context.textThemeColors.brandTextLight,
            ),
          ),
          NumberTextInput(
            isDense: true,
            hintText: '',
            contentPadding: AppPadding.pv8,
            textAlign: TextAlign.center,
            controller: controller,
            errorStyle: TextStyle(height: 0.01),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return value.isNotNullOrEmpty ? null : '';
            },
            onFieldSubmitted: onFieldSubmitted,
            // suffix: Text(
            //   unit ?? '',
            //   style: AppTextStyle.textSm.addAll(
            //       [AppTextStyle.textSm.leading4, AppTextStyle.medium]).copyWith(
            //     color: context.textThemeColors.brandTextLight,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({this.onCancel, this.onNext});

  final VoidCallback? onCancel;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: SecondaryButton(
            text: context.localization.cancel,
            onTap: onCancel,
          ),
        ),
        Expanded(
          child: PrimaryButton(
            text: context.localization.save,
            onTap: onNext,
          ),
        ),
      ],
    );
  }
}
