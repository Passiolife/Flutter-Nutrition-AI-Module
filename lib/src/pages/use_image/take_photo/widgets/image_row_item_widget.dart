import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_shadow.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/widgets/icons/trash_icon_widget.dart';

class ImageRowItemWidget extends StatelessWidget {
  const ImageRowItemWidget({
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
    return Column(
      spacing: 8.h,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: isSelected,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: _DeleteIconWidget(
            onDelete: onDelete,
          ),
        ),
        _ImageRow(
          image: image,
          isSelected: isSelected,
          onTap: onTap,
        ),
      ],
    );
  }
}

class _ImageRow extends StatelessWidget {
  final Uint8List image;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ImageRow({
    required this.image,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Container(
          margin: EdgeInsets.only(right: 8.w),
          decoration: AppShadows.base,
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Image.memory(
              image,
              width: isSelected ? 100.r : 80.r,
              height: isSelected ? 100.r : 80.r,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteIconWidget extends StatelessWidget {
  const _DeleteIconWidget({this.onDelete});

  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDelete,
      child: CircleAvatar(
        backgroundColor: context.colorScheme.surface.withValues(alpha: 0.4),
        radius: 17.r,
        child: TrashIconWidget(),
      ),
    );
  }
}
