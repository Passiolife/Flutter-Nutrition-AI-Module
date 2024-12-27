import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/util/keyboard_extension.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_loading_button_widget.dart';
import '../../../common/widgets/app_text_field.dart';

class ChatActionWidget extends StatefulWidget {
  const ChatActionWidget({
    this.onTapCamera,
    this.onTapGallery,
    this.onTapSend,
    this.visibleLoadingForSendButton = false,
    super.key,
  });

  final VoidCallback? onTapCamera;
  final VoidCallback? onTapGallery;
  final Function(String message)? onTapSend;
  final bool visibleLoadingForSendButton;

  @override
  State<ChatActionWidget> createState() => ChatActionWidgetState();
}

class ChatActionWidgetState extends State<ChatActionWidget> {
  final _messageController = TextEditingController(text: '');
  final _visibleAddActions = ValueNotifier(false);
  final _sendEnabled = ValueNotifier(false);

  @override
  void initState() {
    _messageController.addListener(() {
      _visibleAddActions.value = false;
      _sendEnabled.value = _messageController.text.isNotEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    _sendEnabled.dispose();
    _visibleAddActions.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: _visibleAddActions,
                builder: (context, value, child) {
                  return AppTextField(
                    controller: _messageController,
                    prefixIcon: AnimatedCrossFade(
                      crossFadeState: value
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: widget.visibleLoadingForSendButton ? 0.4 : 1.0,
                        child: IconWidget(
                          icon: AppImages.icPlusSolid,
                          onTap: widget.visibleLoadingForSendButton
                              ? null
                              : () {
                                  setVisibleAddActions(true);
                                },
                        ),
                      ),
                      secondChild: Row(
                        children: [
                          Expanded(
                            child: IconWidget(
                              icon: AppImages.icCamera,
                              onTap: widget.onTapCamera,
                            ),
                          ),
                          Expanded(
                            child: IconWidget(
                              icon: AppImages.icGallery,
                              onTap: widget.onTapGallery,
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 250),
                    ),
                    prefixIconConstraints: BoxConstraints(
                        maxWidth: 48.w * (_visibleAddActions.value ? 2 : 1),
                        maxHeight: 42.h),
                    hintText: context.localization?.typeMessageHint,
                    style: AppTextStyle.textSm
                        .addAll([AppTextStyle.textSm.leading5]).copyWith(
                            color: AppColors.gray900),
                    hintStyle: AppTextStyle.textSm
                        .addAll([AppTextStyle.textSm.leading5]).copyWith(
                            color: AppColors.gray500),
                    inputAction: TextInputAction.send,
                    onFieldSubmitted: (value) {
                      _onTapSend(value);
                    },
                    onTap: () {
                      if (_visibleAddActions.value) {
                        setVisibleAddActions(false);
                      }
                    },
                  );
                }),
          ),
          8.horizontalSpace,
          ValueListenableBuilder(
              valueListenable: _sendEnabled,
              builder: (context, value, child) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: value ? 1 : 0.4,
                  child: AppButton(
                    prefix: widget.visibleLoadingForSendButton
                        ? const AppLoadingButtonWidget(color: AppColors.white)
                        : null,
                    buttonText: widget.visibleLoadingForSendButton
                        ? ''
                        : context.localization?.send,
                    appButtonModel: value
                        ? AppButtonStyles.primary.copyWith(
                            padding: EdgeInsets.symmetric(
                                vertical: 9.h, horizontal: 16.w))
                        : AppButtonStyles.primary.copyWith(
                            padding: EdgeInsets.symmetric(
                                vertical: 9.h, horizontal: 16.w),
                            decoration: AppButtonStyles.primary.decoration
                                ?.copyWith(
                                    color: AppButtonStyles
                                        .primary.decoration?.color
                                        ?.withOpacity(0.4)),
                          ),
                    onTap: !widget.visibleLoadingForSendButton && value
                        ? () => _onTapSend(_messageController.text)
                        : null,
                  ),
                );
              }),
        ],
      ),
    );
  }

  void setVisibleAddActions(bool visible) {
    _visibleAddActions.value = visible;
  }

  void _onTapSend(String value) {
    if (value.isNotEmpty) {
      setVisibleAddActions(false);
      context.hideKeyboard();
      widget.onTapSend?.call(_messageController.text);
      _messageController.clear();
    }
  }
}

class IconWidget extends StatelessWidget {
  const IconWidget({
    required this.icon,
    this.onTap,
    super.key,
  });

  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.only(
        left: 2.r,
        top: 2.r,
        right: 8.r,
        bottom: 2.r,
      ),
      onPressed: onTap,
      icon: Container(
        decoration: BoxDecoration(
          color: AppColors.indigo600Main,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
            width: 16.r,
            height: 16.r,
          ),
        ),
      ),
    );
  }
}
