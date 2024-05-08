import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import 'interfaces.dart';

// Widget responsible for displaying a bottom sheet with a draggable area
class BottomBackgroundWidget extends StatefulWidget {
  const BottomBackgroundWidget({
    this.shouldDraggable = true,
    this.visibleDragIntro = true,
    this.listener,
    this.child,
    super.key,
  });

  // Flag to determine if the sheet should be draggable
  final bool shouldDraggable;

  final bool visibleDragIntro;

  // Listener for drag events
  final FoodScanListener? listener;

  // Child widget to display inside the sheet
  final Widget? child;

  @override
  State<BottomBackgroundWidget> createState() => BottomBackgroundWidgetState();
}

class BottomBackgroundWidgetState extends State<BottomBackgroundWidget> {
  // Maximum size of the draggable area
  double get maxSize => 0.6;
  late double _maxSize;

  // Initial size of the draggable area
  double get _initialSize =>
      widget.shouldDraggable && widget.visibleDragIntro ? 0.35 : 0.3;

  final DraggableScrollableController _scrollableController =
      DraggableScrollableController();

  final ValueNotifier<double> currentHeightInPixels = ValueNotifier(0);

  ScrollController? scrollController;

  @override
  void initState() {
    _maxSize = maxSize;
    _scrollableController.addListener(() {
      if (_scrollableController.isAttached) {
        // Listener to track scroll controller changes
        widget.listener
            ?.onDragResult(_scrollableController.size == _initialSize);
        currentHeightInPixels.value = getDraggedPixels();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // Dispose scroll controller
    _scrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      shouldCloseOnMinExtent: false,
      minChildSize: _initialSize,
      initialChildSize: _initialSize,
      maxChildSize: widget.shouldDraggable ? _maxSize : _initialSize,
      controller: _scrollableController,
      builder: (context, controller) {
        scrollController = controller;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimens.r16),
              topRight: Radius.circular(AppDimens.r16),
            ),
          ),
          // duration: const Duration(milliseconds: AppDimens.duration250),
          child: widget.child,
        );
      },
    );
  }

  // Calculate the amount of pixels the sheet has been dragged
  double getDraggedPixels() {
    return _scrollableController.isAttached
        ? _scrollableController.sizeToPixels(
            (_scrollableController.size >= _maxSize)
                ? _maxSize - _initialSize
                : _scrollableController.size - _initialSize)
        : 0;
  }

  double getInitialSizePixels() {
    return _scrollableController.isAttached
        ? _scrollableController.sizeToPixels(_initialSize)
        : 0;
  }

  // Function to set the initial height of the sheet
  void setInitialHeight() {
    _scrollableController.animateTo(
      _initialSize,
      duration: const Duration(milliseconds: AppDimens.duration400),
      curve: Curves.ease,
    );
  }

  void setMaxSizeWithInitialInPixels(double pixels) {
    if (_scrollableController.isAttached) {
      final size = _initialSize + _scrollableController.pixelsToSize(pixels);
      if (size < maxSize) {
        setState(() {
          _maxSize = size;
        });
      }
    }
  }
}
