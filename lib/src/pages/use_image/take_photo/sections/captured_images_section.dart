import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/extension/context_extension.dart';
import '../bloc/take_photo_bloc.dart';
import '../widgets/image_row_item_widget.dart';

class CapturedImagesSection extends StatefulWidget {
  const CapturedImagesSection({super.key});

  @override
  State<CapturedImagesSection> createState() => _CapturedImagesSectionState();
}

class _CapturedImagesSectionState extends State<CapturedImagesSection> {
  List<Uint8List> _images = [];

  final PageController _controller = PageController(viewportFraction: 0.2);

  final ValueNotifier<int> _selected = ValueNotifier(0);

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoBloc, TakePhotoState>(
      buildWhen: (_, state) {
        return state is TakePhotoSuccessListenerState || state is RemovePhotoListenerState;
      },
      builder: (context, state) {
        if(state is TakePhotoSuccessListenerState) {
          _images = state.resizedImages;
          if (_controller.page?.toInt() != 0) {
            _controller.animateToPage(0,
                duration: const Duration(milliseconds: 250), curve: Curves.linear);
          }
        } else if(state is RemovePhotoListenerState) {
          _images = state.resizedImages;
          if (_controller.page?.toInt() != 0) {
            _controller.animateToPage(0,
                duration: const Duration(milliseconds: 250), curve: Curves.linear);
          }
        }
        return Positioned(
          bottom: context.bottomPadding + 40.h + 78.h + 32.h,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 148.h,
            child: ValueListenableBuilder(
              valueListenable: _selected,
              builder: (context, value, child) {
                return PageView.builder(
                  controller: _controller,
                  itemCount: _images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return ImageRowItemWidget(
                      image: _images.elementAt(index),
                      isSelected: index == value,
                      onTap: () {
                        _changePage(index);
                      },
                      onDelete: () => _deleteImage(index),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _changePage(int index) {
    _controller.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  void _deleteImage(int index) {
    context.read<TakePhotoBloc>().add(DoRemoveImageEvent(index: index));
  }
}
