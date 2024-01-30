part of '../segment_animation.dart';

/// [Background] class is [StatelessWidget] class.
/// This class creates a background in segments.
class Background extends StatelessWidget {
  const Background(
      {required this.width,
      required this.height,
      required this.bgColor,
      super.key});

  /// [height] property set the width of segment background.
  final double width;

  /// [height] property set the height of segment background.
  final double height;

  /// [bgColor] property set the background color of segments..
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        surfaceTintColor: bgColor,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AnimatedSegmentDimens.radiusLarge),
        ),
        color: bgColor,
      ),
    );
  }
}
