import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/string_extensions.dart';
import 'interfaces.dart';

class AlternativeRowWidget extends StatelessWidget {
  const AlternativeRowWidget({required this.data, this.listener, super.key});
  final String? data;

  final PassioSearchListener? listener;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      height: AppDimens.h76,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppColors.blue50,
          highlightColor: AppColors.blue50,
          onTap: () => listener?.onNameSelected(data.toUpperCaseWord),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.r16),
            child: Center(
              child: Text(
                data.toUpperCaseWord ?? '',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: AppTextStyle.textSm.addAll([
                  AppTextStyle.textSm.leading5,
                  AppTextStyle.semiBold
                ]).copyWith(color: AppColors.gray900),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
