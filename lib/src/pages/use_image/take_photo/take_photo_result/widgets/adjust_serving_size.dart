import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../../../../../common/util/double_extensions.dart';
import '../../../../../common/util/navigation_utils/hero_dialog_route.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/button/secondary_button.dart';
import '../../../../../common/widgets/icons/icon_pencil_alt_widget.dart';
import '../../../../../common/widgets/passio/food_item_row.dart';
import '../../../../../common/widgets/passio/serving_size_widget.dart';
import 'edit_nutrition_facts.dart';

class AdjustServingSize extends StatefulWidget {
  const AdjustServingSize({required this.foodRecord, this.index, super.key});

  final FoodRecord foodRecord;
  final int? index;

  static Future<FoodRecord?> navigate({
    required BuildContext context,
    required FoodRecord foodRecord,
    int? index,
  }) async {
    return await Navigator.push(
      context,
      HeroDialogRoute(
        child: AdjustServingSize(
          foodRecord: foodRecord,
          index: index,
        ),
      ),
    );
  }

  @override
  State<AdjustServingSize> createState() => _AdjustServingSizeState();
}

class _AdjustServingSizeState extends State<AdjustServingSize> {
  late FoodRecord _foodRecord;

  @override
  void initState() {
    super.initState();
    _foodRecord = widget.foodRecord.clone();
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
              margin: AppPadding.pa16,
              // margin: AppPadding.pa16 + context.keyboardHeight,
              child: Column(
                spacing: 16.h,
                children: [
                  Text(
                    context.localization.adjustServingSize ?? '',
                    style: AppTextStyle.textXl.addAll([
                      AppTextStyle.textXl.leading7,
                      AppTextStyle.bold,
                    ]),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FoodItemRow(
                          index: widget.index,
                          iconId: _foodRecord.iconId,
                          title: _foodRecord.name,
                          subtitle:
                              '${_foodRecord.getSelectedQuantity().format()} ${_foodRecord.getSelectedUnit()} (${_foodRecord.computedWeight.value.format()} ${_foodRecord.computedWeight.symbol})',
                        ),
                      ),
                      Visibility(
                        visible: true,//_foodRecord.resultType == PassioFoodResultType.nutritionFacts,
                        child: IconPencilAltWidget(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            // FocusManager.instance.primaryFocus?.unfocus();
                            final newFoodRecord = await EditNutritionFacts.navigate(
                              context: context,
                              foodRecord: _foodRecord,
                            );
                            if(newFoodRecord!=null) {
                              setState(() {
                                _foodRecord = newFoodRecord;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  ServingSizeWidget(
                    initialQuantity: _foodRecord.getSelectedQuantity(),
                    initialUnit: _foodRecord.getSelectedUnit(),
                    units: _foodRecord.servingUnits
                        .map((e) => e.unitName)
                        .toList(),
                    onServingSizeChanged: (servingSize) {
                      _foodRecord.setSelectedQuantity(servingSize.quantity);
                      _foodRecord
                          .setUnitWithQuantityAdjustment(servingSize.unit);
                      setState(() {});
                    },
                  ),
                  _ActionButtons(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onDone: () {
                      Navigator.pop(context, _foodRecord);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({this.onCancel, this.onDone});

  final VoidCallback? onCancel;
  final VoidCallback? onDone;

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
            text: context.localization.done,
            onTap: onDone,
          ),
        ),
      ],
    );
  }
}
