import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/context_extension.dart';

class AnalyzingWidget extends StatefulWidget {
  const AnalyzingWidget({super.key});

  @override
  State<AnalyzingWidget> createState() => _AnalyzingWidgetState();
}

class _AnalyzingWidgetState extends State<AnalyzingWidget> {
  // Timer for managing the analysis progress updates
  Timer? _analyzeTImer;

  // Variable to keep track of the current progress percentage (0 - 100)
  int _progress = 0;

  // Duration for the analysis in seconds
  static const int _analyzeDuration = 5;

  // Interval in milliseconds for how often to update the progress
  final int _interval = 50;

  // The progress percentage at which to stop the analysis
  final int _stopAt = 90;

  // Flag to bypass the stopping condition, allowing the analysis to continue past _stopAt
  bool _bypassStop = false;

  @override
  void didChangeDependencies() {
    bool analyze =
        true; //context.watch<FoodLogCubit>().state.animateAnalyzeProgress;
    if (analyze) {
      _startAnalyzeProgress();
    } else {
      _finishAnalyzeProgress();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _analyzeTImer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.all(20.r),
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _progress / 100,
            minHeight: 12.h,
            backgroundColor: context.colorScheme.surface,
            valueColor:
                AlwaysStoppedAnimation<Color>(context.theme.primaryColor),
            borderRadius: BorderRadius.circular(24.r),
          ),
          8.verticalSpace,
          Text(
            context.localization?.generatingResults ?? '',
            style: AppTextStyle.textSm.addAll([AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
          ),
          /*Text(
            context.translation.analyzing,
            style: ThemeFonts.labelSmall
                .merge(ThemeFonts.semiBold)
                .copyWith(color: ColorConstants.textStrong950),
          ),
          Text(
            '$_progress%',
            style: ThemeFonts.paragraphMedium
                .merge(ThemeFonts.regular)
                .copyWith(color: ColorConstants.textStrong950),
          ),
          4.verticalSpace,
          LinearProgressIndicator(
            value: _progress / 100,
            minHeight: 12.h,
            backgroundColor: ColorConstants.bgSoft100,
            valueColor:
                const AlwaysStoppedAnimation<Color>(ColorConstants.primaryBase),
            borderRadius: BorderRadius.circular(24.r),
          ),*/
        ],
      ),
    );
  }

  // Starts the analysis progress update
  void _startAnalyzeProgress() {
    // Calculate the increment value based on the total duration and interval
    final int increment = (100 / (_analyzeDuration * 1000 / _interval)).round();

    // Create a periodic timer to update progress at specified intervals
    _analyzeTImer = Timer.periodic(
      Duration(milliseconds: _interval),
      (timer) {
        // Calculate the new progress value
        final progress = _progress + increment;

        // Ensure progress stays between 0 and 100
        final clampedProgress = progress.clamp(0, 100);

        // Check if the progress is less than or equal to the stopping point
        if (clampedProgress <= _stopAt || _bypassStop) {
          // Update the state with the new progress value
          setState(() {
            _progress = clampedProgress;
          });

          if (_progress == 100) {
            _analyzeTImer?.cancel();
          }
        }
      },
    );
  }

  // Stops the analysis progress update and sets progress to 100%
  void _finishAnalyzeProgress() {
    setState(() {
      _bypassStop = true;
    });
  }
}
