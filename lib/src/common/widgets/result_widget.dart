import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_constants.dart';
import '../extension/context_extension.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_loading_button_widget.dart';
import '../../common/widgets/draggable_bottom_sheet_widget.dart';
import '../../common/widgets/search_manually_widget.dart';

class ResultWidget<T> extends StatefulWidget {
  const ResultWidget({
    required this.itemBuilder,
    this.emptyBuilder,
    this.title,
    this.subtitle,
    this.data,
    this.onChangeSelection,
    this.clearVisible = false,
    this.onClear,
    this.searchVisible = false,
    this.onTapSearch,
    this.neutralButtonText,
    this.onNeutralClick,
    this.negativeButtonText,
    this.onNegativeClick,
    this.positiveButtonText,
    this.positiveButtonEnabled = false,
    this.onPositiveClick,
    this.visibleLoadingForPositiveButton = false,
    this.onCalculateResultSize,
    super.key,
  });

  final NullableIndexedWidgetBuilder itemBuilder;
  final Widget Function()? emptyBuilder;

  final String? title;
  final String? subtitle;

  final List<T>? data;
  final Function(int index, T data)? onChangeSelection;

  final bool clearVisible;
  final VoidCallback? onClear;

  final bool searchVisible;
  final VoidCallback? onTapSearch;

  final String? neutralButtonText;
  final VoidCallback? onNeutralClick;

  final String? negativeButtonText;
  final VoidCallback? onNegativeClick;

  final String? positiveButtonText;
  final bool positiveButtonEnabled;
  final VoidCallback? onPositiveClick;
  final bool visibleLoadingForPositiveButton;

  final Function(double size)? onCalculateResultSize;

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  double get _defaultSize => 0.35;

  // Maximum size of the draggable area
  double get _maxSize => 0.5;

  final DraggableScrollableController _dragController =
      DraggableScrollableController();

  double _size = 0;

  @override
  void initState() {
    _size = _defaultSize;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _size = _calculateSize();
      });
    });
    super.initState();
  }

  // Initial size of the draggable area
  double _calculateSize() {
    final listSize =
        _dragController.pixelsToSize((widget.data?.length ?? 1) * 60.h);
    if ((listSize + _defaultSize) > _maxSize) {
      widget.onCalculateResultSize?.call(_maxSize);
      return _maxSize;
    }
    final calculatedSize = _defaultSize + listSize;
    widget.onCalculateResultSize?.call(calculatedSize);
    return calculatedSize;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheetWidget(
      initialSize: _size,
      minSize: _size,
      maxSize: _size,
      // shouldDraggable: false,
      dragController: _dragController,
      builder: (context, dragController, scrollController, widgetState) {
        return Container(
          decoration: AppShadows.base,
          height: context.height,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: widget.clearVisible ? 1 : 0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: widget.onClear,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              context.localization?.clear ?? '',
                              style: AppTextStyle.textSm.addAll([
                                AppTextStyle.textSm.leading5,
                              ]).copyWith(
                                decoration: AppTextStyle.underline,
                                decorationColor: AppColors.indigo600Main,
                                color: AppColors.indigo600Main,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.title ?? '',
                      style: AppTextStyle.textXl.addAll([
                        AppTextStyle.textXl.leading7,
                        AppTextStyle.bold
                      ]).copyWith(color: AppColors.gray900),
                    ),
                    4.verticalSpace,
                    Text(
                      widget.subtitle ?? '',
                      style: AppTextStyle.textSm,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ((widget.data?.length ?? 0) > 0 ||
                        widget.emptyBuilder == null)
                    ? ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        itemCount: widget.data?.length ?? 0,
                        itemBuilder: widget.itemBuilder,
                        separatorBuilder: (context, index) => 8.verticalSpace,
                      )
                    : widget.emptyBuilder?.call() ?? const SizedBox.shrink(),
              ),
              Visibility(
                visible: widget.searchVisible,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: SearchManuallyWidget(onTap: widget.onTapSearch),
                ),
              ),
              8.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonText: widget.neutralButtonText,
                      appButtonModel: AppButtonStyles.primaryBordered,
                      onTap: widget.onNeutralClick,
                    ),
                  ),
                  SizedBox(width: AppDimens.w16),
                  Expanded(
                    child: AppButton(
                      prefix: widget.visibleLoadingForPositiveButton
                          ? const AppLoadingButtonWidget(color: AppColors.white)
                          : null,
                      buttonText: widget.visibleLoadingForPositiveButton
                          ? ''
                          : context.localization?.logSelected,
                      appButtonModel: widget.positiveButtonEnabled
                          ? AppButtonStyles.primary
                          : AppButtonStyles.primary.copyWith(
                              decoration: AppButtonStyles.primary.decoration
                                  ?.copyWith(
                                      color: AppButtonStyles
                                          .primary.decoration?.color
                                          ?.withOpacity(0.4)),
                            ),
                      onTap: widget.positiveButtonEnabled
                          ? widget.onPositiveClick
                          : null,
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 64.w),
                  child: AppButton(
                    buttonText: widget.negativeButtonText,
                    appButtonModel: AppButtonStyles.primaryBordered,
                    onTap: widget.onNegativeClick,
                  ),
                ),
              ),
              (context.bottomPaddingValue + 16.h).verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
