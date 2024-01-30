import 'dart:io';

import 'package:flutter/material.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/util/context_extension.dart';

class FoodResultSearchingWidget extends StatelessWidget {
  const FoodResultSearchingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.passioInset,
      surfaceTintColor: AppColors.passioInset,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r16)),
      child: Container(
        height: Dimens.h100,
        padding: EdgeInsets.only(top: Dimens.h16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: Dimens.w16),
                SizedBox(
                  width: Dimens.r36,
                  height: Dimens.r36,
                  child: Center(
                    child: Transform.scale(
                      scale: Platform.isIOS ? 1.5 : 1,
                      child: const CircularProgressIndicator.adaptive(backgroundColor: AppColors.passioMedContrast),
                    ),
                  ),
                ),
                SizedBox(width: Dimens.w16),
                Text(context.localization?.scanningForFood ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
