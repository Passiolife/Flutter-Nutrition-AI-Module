import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/context_extension.dart';

class NutritionInformationMessageWidget extends StatefulWidget {
  const NutritionInformationMessageWidget({super.key});

  @override
  State<NutritionInformationMessageWidget> createState() =>
      _NutritionInformationMessageWidgetState();
}

class _NutritionInformationMessageWidgetState
    extends State<NutritionInformationMessageWidget> {
  final ValueNotifier<bool> _isMessageVisible = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isMessageVisible,
      builder: (context, value, child) {
        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          firstChild: child ?? const SizedBox.shrink(),
          secondChild: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.w20),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _isMessageVisible.value = true;
                },
                child: SvgPicture.asset(
                  AppImages.icInformationCircle,
                  width: AppDimens.r24,
                  height: AppDimens.r24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.gray400,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          crossFadeState:
              value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppDimens.w16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.r16),
          color: AppColors.white,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _isMessageVisible.value = false;
                },
                child: Padding(
                  padding: EdgeInsets.all(AppDimens.r4),
                  child: SvgPicture.asset(
                    AppImages.icCloseSolid,
                    width: AppDimens.r24,
                    height: AppDimens.r24,
                    colorFilter: const ColorFilter.mode(
                        AppColors.gray400, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.w16,
                vertical: AppDimens.h24,
              ),
              child: Text(
                context.localization?.nutritionInformationMessage ?? '',
                style: AppTextStyle.textSm
                    .addAll([AppTextStyle.textSm.leading5]).copyWith(
                        color: AppColors.gray900),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
