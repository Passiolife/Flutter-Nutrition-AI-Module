import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constant/app_constants.dart';
import '../../../extension/context_extension.dart';
import '../../loading/shimmer_loading.dart';
import '../../passio_image_widget_new.dart';

class BaseFoodItemRow extends StatelessWidget {
  const BaseFoodItemRow({
    required this.iconId,
    required this.title,
    required this.subtitle,
    this.image,
    this.index,
    this.onTap,
    this.rippleColor,
    this.isLoading = false,
    this.enableSlidable = false,
    this.endActionPane,
    super.key,
  });

  final Uint8List? image;
  final String iconId;
  final String title;
  final String subtitle;
  final int? index;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final bool isLoading;
  final bool enableSlidable;
  final ActionPane? endActionPane;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enableSlidable,
      key: UniqueKey(),
      endActionPane: endActionPane,
      child: ShimmerLoading(
        isLoading: isLoading,
        child: Container(
          decoration: AppShadows.base,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: AppColors.blue50,
              highlightColor: AppColors.blue50,
              onTap: onTap,
              child: Padding(
                padding: AppPadding.pr8,
                child: Row(
                  children: [
                    PassioImageWidget(
                      key: ValueKey('${image?.hashCode}-$iconId-$index'),
                      image: image,
                      iconId: iconId,
                      heroTag: '$iconId $index',
                      radius: 20.r,
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: '$title $index',
                            child: Text(
                              title,
                              style: AppTextStyle.textSm.addAll([
                                AppTextStyle.textSm.leading5,
                                AppTextStyle.semiBold
                              ]),
                            ),
                          ),
                          Hero(
                            tag: '$subtitle $index',
                            child: Text(
                              subtitle,
                              style: AppTextStyle.textSm
                                  .addAll([AppTextStyle.textSm.leading5]).copyWith(
                                      color:
                                          context.textThemeColors.brandTextLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
