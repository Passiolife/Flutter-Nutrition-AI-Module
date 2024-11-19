import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScannerWidget extends AnimatedWidget {
  const ScannerWidget({
    required Animation<double> animation,
    required this.animationColor,
    this.isStopped = true,
    super.key,
  }) : super(listenable: animation);

  final Color animationColor;
  final bool isStopped;

  ({List<Color> forwardColors, List<Color> reverseColors}) get colors => (
        forwardColors: [
          animationColor.withAlpha(80),
          animationColor.withOpacity(00),
        ],
        reverseColors: [
          animationColor.withOpacity(00),
          animationColor.withAlpha(80),
        ],
      );

  Animation<double> get animationData => (listenable as Animation<double>);

  bool get isReverse => animationData.status == AnimationStatus.reverse;

  // Calculates the vertical position of the scanner based on animation progress.
  // AppDimens.h110: Represents the top space.
  // AppDimens.r8: Represents a random white line offset from the top.
  // AppDimens.r100: Represents the height for the top line.
  // AppDimens.h180: Represents the vertical space between the top and bottom.
  // AppDimens.h24: Represents the height for the bottom line.
  double? get scorePosition => (110.h +
      8.r +
      animationData.value * (100.r + 180.h + 24.h));

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: scorePosition,
      left: 24.w,
      right: 24.w,
      child: Opacity(
        opacity: isStopped ? 0.0 : 1.0,
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.1, 0.9],
              colors: isReverse ? colors.reverseColors : colors.forwardColors,
            ),
          ),
        ),
      ),
    );
  }
}
