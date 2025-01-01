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

class EditNutritionFacts extends StatelessWidget {
  const EditNutritionFacts({super.key});

  static void navigate({required BuildContext context}) {
    Navigator.push(
      context,
      HeroDialogRoute(
        child: EditNutritionFacts(),
      ),
    );
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
                  _DetailsWidget(),
                  _NutritionFactsWidget(),
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
  const _DetailsWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PassioImageWidget(
          iconId: '',
          radius: 20.r,
        ),
        8.horizontalSpace,
        Expanded(
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextInput(hintText: ''),
              PrimaryTextInput(hintText: ''),
            ],
          ),
        ),
      ],
    );
  }
}

class _NutritionFactsWidget extends StatelessWidget {
  const _NutritionFactsWidget();

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
              // unit: context.localization.cal
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
            hintText: '',
            contentPadding: AppPadding.pv10,
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
              flex: 3
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
