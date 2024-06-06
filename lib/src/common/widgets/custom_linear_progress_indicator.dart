import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  const CustomLinearProgressIndicator({
    this.value,
    this.maxValue,
    this.backgroundColor,
    this.color,
    this.minHeight,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  /// The minimum height of the line used to draw the linear indicator.
  ///
  /// If [minHeight] is null then it will use the
  /// ambient [ProgressIndicatorThemeData.linearMinHeight]. If that is null
  /// it will use 4dp.
  final double? minHeight;

  final double? value;
  final double? maxValue;
  final Color? backgroundColor;
  final Color? color;

  /// The border radius of both the indicator.
  ///
  /// By default it is [BorderRadius.zero].
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Stack(
          children: [
            Container(
              width: constraints.maxWidth,
              height: minHeight ??
                  Theme.of(context).progressIndicatorTheme.linearMinHeight ??
                  4,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: (maxValue ?? 0) > 0
                  ? ((value ?? 0) * constraints.maxWidth) / (maxValue ?? 0)
                  : 0,
              height: minHeight ??
                  Theme.of(context).progressIndicatorTheme.linearMinHeight ??
                  4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: borderRadius,
              ),
            ),
          ],
        );
      },
    );
  }
}
