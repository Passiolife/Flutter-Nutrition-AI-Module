import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/extension/context_extension.dart';

typedef ColorBuilder = List<Color> Function(bool isReversed);
typedef BorderBuilder = BoxBorder? Function(bool isReversed);

class ScanningAnimationWidget extends StatefulWidget {
  const ScanningAnimationWidget({
    this.duration = const Duration(milliseconds: 2000),
    super.key,
  });

  final Duration duration;

  @override
  State<ScanningAnimationWidget> createState() =>
      ScanningAnimationWidgetState();
}

class ScanningAnimationWidgetState extends State<ScanningAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // Controls the animation state

  @override
  void initState() {
    // Initialize the AnimationController with the duration provided by the widget
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reverse the animation when it reaches the end
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Forward the animation when it reaches the start
        _animationController.forward();
      }
    });

    // Start the animation after the initial frame is rendered
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _startScanningAnimation();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: context.height,
      child: _ScannerWidget(
        animation: _animationController,
        // Pass reverse colors for animation
        colorBuilder: (isReversed) {
          if (isReversed) {
            return [
              Colors.white.withValues(alpha: 0.41),
              Colors.black.withValues(alpha: 0),
            ];
          } else {
            return [
              Colors.black.withValues(alpha: 0),
              Colors.white.withValues(alpha: 0.41),
            ];
          }
        }, //  widget.colorBuilder,
        borderBuilder: (isReversed) {
          return isReversed
              ? Border(
                  top: BorderSide(
                    color: Colors.white,
                    width: 2.r,
                  ),
                )
              : Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 2.r,
                  ),
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    // Stop the animation and dispose of the controller when the widget is destroyed
    stopScanningAnimation();
    _animationController.dispose();
    super.dispose();
  }

  // Method to stop the scanning animation and reset the controller
  void stopScanningAnimation() {
    if (isRunningAnimation()) {
      _animationController.reset(); // Reset animation state
      _animationController.stop(); // Stop the animation
    }
  }

  // Method to start the scanning animation if it's not already running
  void _startScanningAnimation() {
    if (!isRunningAnimation()) {
      _animationController.forward(); // Start the animation
    }
  }

  // Helper method to check if the animation is currently running
  bool isRunningAnimation() {
    return _animationController.isAnimating;
  }
}

// Widget that visualizes the scanning animation
class _ScannerWidget extends AnimatedWidget {
  const _ScannerWidget({
    required Animation<double> animation, // Animation controller
    required this.colorBuilder,
    required this.borderBuilder,
  }) : super(listenable: animation);

  final ColorBuilder colorBuilder;
  final BorderBuilder borderBuilder;

  // Helper to access the animation value
  Animation<double> get animationData => (listenable as Animation<double>);

  // Check if the animation is running in reverse
  bool get isReverse => animationData.status == AnimationStatus.reverse;

  double get _scannerHeight => 150.h;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the available width and height from the parent widget
        final double parentHeight = constraints.maxHeight;
        final double parentWidth = constraints.maxWidth;
        final double position =
            animationData.value * (parentHeight + _scannerHeight) -
                _scannerHeight;

        // Build the animated widget
        return Align(
          alignment: Alignment.topCenter, // Align the container to the top
          child: Container(
            transform: Matrix4.translationValues(0, position, 0),
            // Animate the top margin
            height: _scannerHeight,
            // Set the height (can be adjusted)
            width: parentWidth,
            // Set the width to fill the parent
            decoration: BoxDecoration(
              border: borderBuilder.call(isReverse),
              // Apply the optional border
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.1, 0.9], // Define gradient stops
                colors: colorBuilder(isReverse),
              ),
            ),
          ),
        );
      },
    );
  }
}
