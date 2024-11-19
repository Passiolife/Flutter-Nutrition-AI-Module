import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ItemBuilder = Widget Function(
  BuildContext context,
  DraggableScrollableController? dragController,
  ScrollController? controller,
  DraggableBottomSheetWidgetState? widgetState,
);
typedef DragListener = Function(double draggedSize, double draggedPixels);

class DraggableBottomSheetWidget extends StatefulWidget {
  const DraggableBottomSheetWidget({
    this.initialSize = 0.5,
    this.minSize = 0.25,
    this.maxSize = 1,
    this.shouldDraggable = true,
    this.shouldCloseOnMinExtent = false,
    this.builder,
    this.backgroundColor = Colors.white,
    this.borderRadius,
    this.dragController,
    this.dragListener,
    super.key,
  });

  final double initialSize;
  final double minSize;
  final double maxSize;
  final bool shouldDraggable;
  final bool shouldCloseOnMinExtent;
  final ItemBuilder? builder;
  final Color backgroundColor;
  final double? borderRadius;
  final DraggableScrollableController? dragController;
  final DragListener? dragListener;

  @override
  State<DraggableBottomSheetWidget> createState() =>
      DraggableBottomSheetWidgetState();
}

class DraggableBottomSheetWidgetState
    extends State<DraggableBottomSheetWidget> {
  ScrollController? _scrollController;
  DraggableScrollableController? _dragController;

  double _maxSize = 1;

  @override
  void initState() {
    _dragController = widget.dragController ?? DraggableScrollableController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.dragListener?.call(getDraggedSize(), getDraggedPixels());
    });
    if (widget.dragListener != null) {
      _dragController?.addListener(() {
        widget.dragListener?.call(getDraggedSize(), getDraggedPixels());
      });
    }
    _maxSize = widget.maxSize;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DraggableBottomSheetWidget oldWidget) {
    _maxSize = widget.maxSize;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // _dragController?.dispose();
    // _scrollController?.dispose();
    // _dragController = null;
    // _scrollController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      shouldCloseOnMinExtent: widget.shouldCloseOnMinExtent,
      minChildSize: widget.minSize,
      initialChildSize: widget.initialSize,
      maxChildSize:
          widget.shouldDraggable ? _maxSize : widget.initialSize,
      controller: _dragController,
      builder: (context, controller) {
        _scrollController = controller;
        return Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.borderRadius ?? 16.r),
              topRight: Radius.circular(widget.borderRadius ?? 16.r),
            ),
          ),
          // duration: const Duration(milliseconds: AppDimens.duration250),
          child: widget.builder
              ?.call(context, _dragController, _scrollController, this),
        );
      },
    );
  }

  DraggableScrollableController? getDragController() => _dragController;

  ScrollController? getScrollController() => _scrollController;

  double getDraggedSize() {
    return (_dragController?.isAttached ?? false)
        ? _dragController?.size ?? 0
        : 0;
  }

  // Calculate the amount of pixels the sheet has been dragged
  double getDraggedPixels() {
    return (_dragController?.isAttached ?? false)
        ? _dragController?.sizeToPixels(getDraggedSize()) ?? 0
        : 0;
  }

  double getInitialSize() {
    return widget.initialSize;
  }

  double getInitialSizePixels() {
    return (_dragController?.isAttached ?? false)
        ? _dragController?.sizeToPixels(getInitialSize()) ?? 0
        : 0;
  }

  // Function to set the initial height of the sheet
  void setInitialHeight() {
    if(!(_dragController?.isAttached ?? false)) return;
    _dragController?.animateTo(
      widget.initialSize,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void setMaxSizeInPixels(double pixels) {
    setState(() {
      _maxSize = _dragController?.pixelsToSize(pixels) ?? widget.maxSize;
    });
  }
}
