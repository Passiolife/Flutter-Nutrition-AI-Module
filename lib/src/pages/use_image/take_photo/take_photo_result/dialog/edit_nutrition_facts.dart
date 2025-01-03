import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/extension/string_extensions.dart';
import '../../../../../common/util/navigation_utils/hero_dialog_route.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/button/secondary_button.dart';
import '../../../../../common/widgets/text_input/number_text_input.dart';
import '../../../../../common/widgets/text_input/primary_text_input.dart';

class EditNutritionFacts extends StatefulWidget {
  const EditNutritionFacts({required this.foodRecord, this.index, super.key});

  final FoodRecord foodRecord;
  final int? index;

  static Future<FoodRecord?> navigate({
    required BuildContext context,
    required FoodRecord foodRecord,
    int? index,
  }) {
    return Navigator.push(
      context,
      HeroDialogRoute(
        child: EditNutritionFacts(
          foodRecord: foodRecord,
          index: index,
        ),
      ),
    );
  }

  @override
  State<EditNutritionFacts> createState() => _EditNutritionFactsState();
}

class _EditNutritionFactsState extends State<EditNutritionFacts> {
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
                  ),
                  _NutritionFactsWidget(
                    index: widget.index,
                    foodRecord: _foodRecord,
                  ),
                  _PortionsWidget(),
                  _ActionButtons(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onNext: () {
                      Navigator.pop(context);
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

class _DetailsWidget extends StatelessWidget {
  const _DetailsWidget({
    required this.index,
    required this.foodRecord,
  });

  final int? index;
  final FoodRecord foodRecord;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PassioImageWidget(
          iconId: foodRecord.iconId,
          radius: 20.r,
          heroTag: '${foodRecord.iconId} $index',
        ),
        8.horizontalSpace,
        Expanded(
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextInput(
                isDense: true,
                hintText: context.localization.enterName.toUpperCaseWord ?? '',
                initialValue: foodRecord.name,
              ),
              PrimaryTextInput(
                isDense: true,
                hintText:
                    context.localization.enterBarcode.toUpperCaseWord ?? '',
                initialValue: foodRecord.barcode,
                readOnly: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NutritionFactsWidget extends StatelessWidget {
  const _NutritionFactsWidget({
    required this.index,
    required this.foodRecord,
  });

  final int? index;
  final FoodRecord foodRecord;

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
              unit: context.localization.cal
            ),
            _buildField(
              context: context,
              title: context.localization.carbs ?? '',
            ),
            _buildField(
              context: context,
              title: context.localization.protein ?? '',
            ),
            _buildField(
              context: context,
              title: context.localization.fat ?? '',
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
  }) {
    return Expanded(
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
            suffix: Text(
              unit ?? '',
              style: AppTextStyle.textSm.addAll(
                  [AppTextStyle.textSm.leading4, AppTextStyle.medium]).copyWith(
                color: context.textThemeColors.brandTextLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortionsWidget extends StatelessWidget {
  const _PortionsWidget();

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
              // unit: context.localization.cal
            ),
            _buildField(
              context: context,
              title: context.localization.weight ?? '',
            ),
            _buildField(
              context: context,
              title: context.localization.unit ?? '',
              flex: 3,
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
            hintText: '',
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
            text: context.localization.next,
            onTap: onNext,
          ),
        ),
      ],
    );
  }
}
