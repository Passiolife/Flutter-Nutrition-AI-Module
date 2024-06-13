import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import '../constant/app_text_styles.dart';
import '../util/context_extension.dart';

class SearchManuallyWidget extends StatelessWidget {
  const SearchManuallyWidget({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: '${context.localization?.notWhatYouAreLookingFor} ',
          style: AppTextStyle.textSm.addAll([AppTextStyle.textSm.leading5]),
          children: [
            TextSpan(
              text: context.localization?.searchManually,
              style: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.bold
              ]).copyWith(color: AppColors.blue600),
            )
          ],
        ),
      ),
    );
  }
}
