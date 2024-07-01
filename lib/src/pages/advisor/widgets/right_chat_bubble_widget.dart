import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/advisor_chat/advisor_chat.dart';

class RightChatBubbleWidget extends StatelessWidget {
  const RightChatBubbleWidget({required this.advisorChat, super.key});

  final AdvisorChat advisorChat;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: advisorChat.images != null
          ? Padding(
              padding: EdgeInsets.only(left: 40.w),
              child: CarousalWidget(images: advisorChat.images ?? []),
            )
          : Container(
              margin: EdgeInsets.only(left: 40.w),
              decoration: BoxDecoration(
                color: AppColors.indigo100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                  bottomRight: const Radius.circular(0),
                ),
              ),
              padding: EdgeInsets.all(8.r),
              child: advisorChat.images != null
                  ? CarousalWidget(images: advisorChat.images ?? [])
                  : TextWidget(
                      text: advisorChat.message ?? '',
                    ),
            ),
    );
  }
}

class CarousalWidget extends StatelessWidget {
  const CarousalWidget({
    this.images = const [],
    super.key,
  });

  final List<Uint8List> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 262.h,
      child: PageView.builder(
        padEnds: false,
        physics: const ClampingScrollPhysics(),
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        controller: PageController(
          initialPage: 0,
          viewportFraction: images.length > 1 ? 0.9 : 1.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.memory(
              images.elementAt(index),
              width: double.infinity,
              height: 262.h,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.textSm.copyWith(
          color: AppColors.gray900,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 0)),
    );
  }
}
