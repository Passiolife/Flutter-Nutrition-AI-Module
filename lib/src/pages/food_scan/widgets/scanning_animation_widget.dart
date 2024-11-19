import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import 'scanner_widget.dart';

class ScanningAnimationWidget extends StatefulWidget {
  const ScanningAnimationWidget({super.key});

  @override
  State<ScanningAnimationWidget> createState() =>
      ScanningAnimationWidgetState();
}

class ScanningAnimationWidgetState extends State<ScanningAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanningAnimationController;

  @override
  void initState() {
    _scanningAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scanningAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _reverseScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        _reverseScanAnimation(false);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 110.h,
          left: 24.w,
          right: 24.w,
          child: SvgPicture.asset(
            AppImages.icScanFrame,
            width: double.infinity,
            fit: BoxFit.fill,
            height: 380.h,
          ),
        ),
        ScannerWidget(
          animation: _scanningAnimationController,
          animationColor: AppColors.white20Opacity,
          isStopped: false,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scanningAnimationController.dispose();
    super.dispose();
  }

  void _reverseScanAnimation(bool reverse) {
    if (reverse) {
      _scanningAnimationController.reverse(from: 1.0);
    } else {
      _scanningAnimationController.forward(from: 0.0);
    }
  }

  void stopScanningAnimation() {
    if (isRunningAnimation()) {
      _scanningAnimationController.reset();
      _scanningAnimationController.stop();
    }
  }

  void startScanningAnimation() {
    if (!isRunningAnimation()) {
      _scanningAnimationController.forward();
    }
  }

  bool isRunningAnimation() {
    return _scanningAnimationController.isAnimating;
  }
}
