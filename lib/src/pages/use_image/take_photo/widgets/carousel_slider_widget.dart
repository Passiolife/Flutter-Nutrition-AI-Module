import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/context_extension.dart';

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({
    required this.images,
    this.onDelete,
    super.key,
  });

  final List<Uint8List> images;
  final Function(int index)? onDelete;

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  final List<Uint8List> _images = [];

  final PageController _controller = PageController(viewportFraction: 0.2);

  final ValueNotifier<int> _selected = ValueNotifier(0);

  @override
  void initState() {
    _images.addAll(widget.images);
    _controller.addListener(_pageChangeListener);
    super.initState();
  }

  void _pageChangeListener() {
    _selected.value = _controller.page?.round() ?? 0;
  }

  @override
  void dispose() {
    _controller.removeListener(_pageChangeListener);
    _controller.dispose();
    _selected.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CarouselSliderWidget oldWidget) {
    if (_images.length != widget.images.length) {
      _images
        ..clear()
        ..addAll(widget.images);
      if (_controller.page?.toInt() != 0) {
        _controller.animateToPage(0,
            duration: const Duration(milliseconds: 250), curve: Curves.linear);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: context.bottomPadding + 40.h + 78.h + 32.h,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 90.h,
        child: ValueListenableBuilder(
          valueListenable: _selected,
          builder: (context, value, child) {
            return PageView.builder(
              controller: _controller,
              itemCount: _images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SliderItemWidget(
                  image: _images.elementAt(index),
                  isSelected: index == value,
                  onTap: () {
                    _changePage(index);
                  },
                  onDelete: () => widget.onDelete?.call(index),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _changePage(int index) {
    _controller.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }
}

class SliderItemWidget extends StatelessWidget {
  const SliderItemWidget({
    required this.image,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final Uint8List image;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              decoration: AppShadows.base,
              clipBehavior: Clip.hardEdge,
              child: Image.memory(
                image,
                width: 80.r,
                height: 80.r,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: onDelete,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 16.r,
                  height: 16.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.red500,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppImages.icCloseSolid,
                      width: 12.r,
                      height: 12.r,
                      colorFilter: const ColorFilter.mode(
                          AppColors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
