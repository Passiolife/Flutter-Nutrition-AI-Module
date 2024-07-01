import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/models/advisor_chat/advisor_chat.dart';
import '../../../common/models/advisor_food_info_log/advisor_food_info_log.dart';
import 'left_chat_bubble_widget.dart';
import 'right_chat_bubble_widget.dart';

typedef FindFoodsCallback = Function(int index, AdvisorChat? advisorChat);
typedef SelectionChangeCallback = Function(int index, int itemIndex,
    AdvisorChat? advisorChat, AdvisorFoodInfoLog advisorFoodInfoLog);
typedef LogCallback = Function(int index, AdvisorChat? advisorChat);

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    this.list,
    this.onTapFindFoods,
    this.onChangeSelection,
    this.onLog,
    super.key,
  });

  final List<AdvisorChat>? list;
  final FindFoodsCallback? onTapFindFoods;
  final SelectionChangeCallback? onChangeSelection;
  final LogCallback? onLog;

  @override
  State<ChatWidget> createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatWidget> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            children: widget.list?.asMap().entries.map<Widget>(
                  (entry) {
                    var index = entry.key;
                    var data = entry.value;
                    if (data.isSentByMe) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: RightChatBubbleWidget(advisorChat: data),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: LeftChatBubbleWidget(
                          advisorChat: data,
                          onTapFindFoods: () =>
                              widget.onTapFindFoods?.call(index, data),
                          onChangeSelection: (itemIndex, advisorFoodInfoLog) =>
                              widget.onChangeSelection?.call(
                                  index, itemIndex, data, advisorFoodInfoLog),
                          onTapLog: () => widget.onLog?.call(index, data),
                        ),
                      );
                    }
                  },
                ).toList() ??
                [],
          ),
        ),
      ),
    );

    return Expanded(
      child: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        physics: const ClampingScrollPhysics(),
        children: widget.list?.asMap().entries.map<Widget>(
              (entry) {
                var index = entry.key;
                var data = entry.value;
                if (data.isSentByMe) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: RightChatBubbleWidget(advisorChat: data),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: LeftChatBubbleWidget(
                      advisorChat: data,
                      onTapFindFoods: () =>
                          widget.onTapFindFoods?.call(index, data),
                      onChangeSelection: (itemIndex, advisorFoodInfoLog) =>
                          widget.onChangeSelection?.call(
                              index, itemIndex, data, advisorFoodInfoLog),
                      onTapLog: () => widget.onLog?.call(index, data),
                    ),
                  );
                }
              },
            ).toList() ??
            [],
      ),
    );
    return Expanded(
      child: ListView.separated(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        itemCount: widget.list?.length ?? 0,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final data = widget.list?.elementAt(index);
          if (data == null) return const SizedBox.shrink();
          if (data.isSentByMe) {
            return RightChatBubbleWidget(advisorChat: data);
          } else {
            return LeftChatBubbleWidget(
              advisorChat: data,
              onTapFindFoods: () => widget.onTapFindFoods?.call(index, data),
              onChangeSelection: (itemIndex, advisorFoodInfoLog) => widget
                  .onChangeSelection
                  ?.call(index, itemIndex, data, advisorFoodInfoLog),
              onTapLog: () => widget.onLog?.call(index, data),
            );
          }
        },
        separatorBuilder: (context, index) {
          return 16.verticalSpace;
        },
      ),
    );
  }

  void scrollToBottom() {
    final position = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(position);
  }
}
