import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/double_extensions.dart';
import '../../../../common/widgets/vector/vector_widget.dart';

class WaterQuickAddItemWidget extends StatelessWidget {
  const WaterQuickAddItemWidget({
    required this.icon,
    required this.type,
    required this.value,
    required this.unit,
    this.width = 24,
    this.height = 24,
    this.onTap,
    super.key,
  });

  final String icon;
  final String type;
  final double value;
  final String unit;
  final VoidCallback? onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.blue50,
        highlightColor: AppColors.blue50,
        onTap: onTap,
        child: SizedBox(
          height: 87.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: VectorWidget(
                    imagePath: icon,
                    width: width,
                    height: height,
                  ),
                ),
              ),
              8.verticalSpace,
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: RichText(
                    text: TextSpan(
                      text: type,
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                        AppTextStyle.semiBold
                      ]),
                      children: [
                        TextSpan(
                          text: ' (${value.format()} $unit)',
                          style: AppTextStyle.textSm.addAll([
                            AppTextStyle.textSm.leading5,
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
