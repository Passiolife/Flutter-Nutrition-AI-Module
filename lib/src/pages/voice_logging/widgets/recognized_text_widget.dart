import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../common/constant/app_constants.dart';

class RecognizedTextWidget extends StatefulWidget {
  const RecognizedTextWidget({
    this.recognizedWords = '',
    super.key,
  });

  final String recognizedWords;

  @override
  State<RecognizedTextWidget> createState() => _RecognizedTextWidgetState();
}

class _RecognizedTextWidgetState extends State<RecognizedTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.indigo50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        toBeginningOfSentenceCase(widget.recognizedWords),
        style: AppTextStyle.textSm
            .addAll([AppTextStyle.textSm.leading5]).copyWith(
                color: AppColors.speechRecognizedTextColor),
      ),
    );
  }
}
