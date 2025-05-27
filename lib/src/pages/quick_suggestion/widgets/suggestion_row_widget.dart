import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/models/quick_suggestion/quick_suggestion.dart';
import '../../../common/widgets/app_loading_button_widget.dart';
import '../../../common/widgets/icons/plus_icon_widget.dart';
import '../../../common/widgets/passio_image_widget.dart';

class SuggestionRowWidget extends StatelessWidget {
  const SuggestionRowWidget({
    required this.suggestion,
    this.isAddLoading = false,
    this.onTap,
    this.onTapAdd,
    super.key,
  });

  final QuickSuggestion suggestion;
  final VoidCallback? onTap;
  final VoidCallback? onTapAdd;
  final bool isAddLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        color: AppColors.indigo50,
        child: Row(
          children: [
            8.horizontalSpace,
            PassioImageWidget(
              key: ValueKey(suggestion.foodRecord?.iconId ??
                  suggestion.passioFoodDataInfo?.iconID ??
                  ''),
              iconId: suggestion.foodRecord?.iconId ??
                  suggestion.passioFoodDataInfo?.iconID ??
                  '',
              radius: 16.r,
              foodRecord: suggestion.foodRecord,
            ),
            8.horizontalSpace,
            Expanded(
              child: Text(
                (suggestion.foodRecord?.name ??
                        suggestion.passioFoodDataInfo?.foodName ??
                        '')
                    .toUpperCaseWord,
                style: AppTextStyle.textXs.addAll(
                    [AppTextStyle.semiBold]).copyWith(color: AppColors.gray900),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            isAddLoading
                ? const AppLoadingButtonWidget()
                : PlusIconWidget(
                    color: AppColors.brandIconLight,
                    width: 16.r,
                    height: 16.r,
                    onTap: onTapAdd,
                  ),
          ],
        ),
      ),
    );
  }
}
