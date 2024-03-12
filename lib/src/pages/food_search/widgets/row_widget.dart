import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/widgets/passio_image_widget.dart';
import 'interfaces.dart';

class RowWidget extends StatelessWidget {
  const RowWidget({required this.index, required this.data, this.listener, super.key});

  final int index;
  final PassioSearchResult data;
  final PassioSearchListener? listener;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.customShadow,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppColors.blue50,
          highlightColor: AppColors.blue50,
          onTap: () => listener?.onFoodItemSelected(data),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.r8),
            child: Row(
              children: [
                PassioImageWidget(
                  iconId: data.iconID,
                  radius: AppDimens.r20,
                  heroTag: '${data.iconID}$index',
                ),
                SizedBox(width: AppDimens.w8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: '${data.foodName}$index',
                        child: Text(
                          data.foodName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.textSm.addAll([
                            AppTextStyle.textSm.leading5,
                            AppTextStyle.semiBold
                          ]).copyWith(color: AppColors.gray900),
                        ),
                      ),
                      data.brandName.isNotEmpty
                          ? Text(
                              data.brandName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.textSm
                                  .copyWith(color: AppColors.gray500),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  AppImages.icPlusSolid,
                  width: AppDimens.r24,
                  height: AppDimens.r24,
                  colorFilter: const ColorFilter.mode(
                      AppColors.gray400, BlendMode.srcIn),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
