part of animated_segment;

/// [SegmentItems] class is [StatelessWidget] class.
/// This class creates a segment.
class SegmentItems extends StatelessWidget {
  const SegmentItems({
    required this.widgets,
    required this.width,
    required this.height,
    required this.segmentTextColor,
    required this.eventBus,
    required this.onEndRenderItems,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  /// [width] property is use to set the width of segment.
  final double width;

  /// [height] property is use to set the height of segment.
  final double height;

  /// [segmentTextColor] property is use to set the text color of segment.
  final Color segmentTextColor;

  /// [widgets] property is use display all segments.
  final List<String> widgets;

  /// [eventBus] property is use send an event on tap of segment.
  final EventBus eventBus;

  /// [onEndRenderItems] property is callback, it calls when render is end.
  final VoidCallback onEndRenderItems;

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: _generateWidgets(),
      ),
    );
  }

  /// [_generateWidgets] is use to generate the widgets.
  List<Widget> _generateWidgets() {
    _widgetSize = (width / widgets.length);
    var list = <Widget>[];
    widgets.asMap().forEach((index, element) {
      list.add(
        InkWell(
          onTap: () => _onTapPressed(index),
          child: Container(
            alignment: Alignment.center,
            width: _widgetSize - 1,
            height: height,
            child: Text(
              element,
              style: AppStyles.style14.copyWith(
                color: index == currentIndex ? AnimatedSegmentAppColors.white : AnimatedSegmentAppColors.themeButtonColor,
              ),
            ),
          ),
        ),
      );
      if (index != widgets.length - 1) {
        list.add(
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AnimatedSegmentAppColors.themeButtonColor,
          ),
        );
      }
    });
    onEndRenderItems();
    return list;
  }

  /// [_onTapPressed] method executes when on click performs on segment.
  void _onTapPressed(int index) {
    eventBus.sendEvent(ItemClickBusEvent(index: index));
  }
}
