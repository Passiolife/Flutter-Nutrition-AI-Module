part of '../quick_suggestion_page.dart';

class _QuickSuggestionScreen extends StatelessWidget {
  const _QuickSuggestionScreen({super.key});

  double _getInitialSize(BuildContext context) {
    // Define the pixel value you want to convert to initialSize
    final double initialPixelValue = context.bottomPaddingValue +
        kBottomNavigationBarHeight +
        26.r +
        8.h +
        5.h +
        16.h +
        20.h +
        4.h +
        14.h;

    // Get the screen height
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate the fraction of the screen height
    return initialPixelValue / screenHeight;
  }

  double get _maxSize => 0.6;


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DraggableBottomSheetWidget(
        initialSize: _getInitialSize(context),
        minSize: _getInitialSize(context),
        maxSize: _maxSize,
        builder: (context, dragController, scrollController, widgetState) {
          return Container(
            decoration: AppShadows.base,
            height: context.height,
            child: Column(
              children: [
                HeaderSection(controller: scrollController),
                BodySection(controller: scrollController),
              ],
            ),
          );
        },
        dragListener: null,
      ),
    );
  }
}
