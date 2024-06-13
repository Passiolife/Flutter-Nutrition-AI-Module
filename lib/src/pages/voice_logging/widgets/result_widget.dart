import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/voice_log/voice_log.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_loading_button_widget.dart';
import '../../../common/widgets/draggable_bottom_sheet_widget.dart';
import '../../../common/widgets/food_item_row_widget.dart';
import '../../../common/widgets/search_manually_widget.dart';
import 'selection_indicator_widget.dart';

class ResultWidget extends StatefulWidget {
  const ResultWidget({
    this.title,
    this.subtitle,
    this.voiceLogs,
    this.onChangeSelection,
    this.clearVisible = false,
    this.onClear,
    this.onTapSearch,
    this.onTryAgain,
    this.logButtonEnabled = false,
    this.onLogSelected,
    this.visibleLoadingForLog = false,
    super.key,
  });

  final String? title;
  final String? subtitle;

  final List<VoiceLog>? voiceLogs;

  final Function(int index, VoiceLog voiceLog)? onChangeSelection;

  final bool clearVisible;
  final VoidCallback? onClear;

  final VoidCallback? onTapSearch;
  final VoidCallback? onTryAgain;

  final bool logButtonEnabled;
  final VoidCallback? onLogSelected;
  final bool visibleLoadingForLog;

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  double get _defaultSize => 0.4;

  // Maximum size of the draggable area
  double get _maxSize => 0.65;

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
        _dragController.pixelsToSize((widget.voiceLogs?.length ?? 0) * 60.h);
    if ((listSize + _defaultSize) > _maxSize) {
      return _maxSize;
    }
    return _defaultSize + listSize;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableBottomSheetWidget(
      initialSize: _size,
      minSize: _size,
      maxSize: _size,
      dragController: _dragController,
      builder: (context, dragController, scrollController) {
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
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  itemCount: widget.voiceLogs?.length ?? 0,
                  itemBuilder: (context, index) {
                    final data = widget.voiceLogs?.elementAt(index);

                    final advisorInfo = data?.recognitionModel?.advisorInfo;

                    final foodDataInfo = advisorInfo?.foodDataInfo;
                    final iconId = foodDataInfo?.iconID ?? '';
                    final title = foodDataInfo?.foodName ?? '';
                    final calories =
                        foodDataInfo?.nutritionPreview.calories ?? 0;
                    final weightQuantity =
                        foodDataInfo?.nutritionPreview.weightQuantity ?? 0;
                    final caloriesPerGram = calories / weightQuantity;
                    final weightGrams = advisorInfo?.weightGrams ?? 0;
                    final caloriesForPortionSize =
                        caloriesPerGram * weightGrams;
                    final portionSize = advisorInfo?.portionSize ??
                        '${weightGrams.format()} ${context.localization?.g}';
                    final subtitle =
                        '$portionSize | ${caloriesForPortionSize.format()} ${context.localization?.cal}';

                    final isSelected = data?.isSelected ?? false;

                    return FoodItemRowWidget(
                      iconId: iconId,
                      title: title,
                      subtitle: subtitle,
                      isAddVisible: false,
                      padding: EdgeInsets.zero,
                      suffix: IconButton(
                        onPressed: () {
                          if (data != null) {
                            widget.onChangeSelection?.call(index, data);
                          }
                        },
                        icon: SelectionIndicator(isSelected: isSelected),
                      ),
                      onTap: () {
                        if (data != null) {
                          widget.onChangeSelection?.call(index, data);
                        }
                      },
                    );
                  },
                  separatorBuilder: (context, index) => 8.verticalSpace,
                ),
              ),
              4.verticalSpace,
              SearchManuallyWidget(onTap: widget.onTapSearch),
              24.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      prefix: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: SvgPicture.asset(
                          AppImages.icMic,
                          colorFilter: const ColorFilter.mode(
                              AppColors.indigo600Main, BlendMode.srcIn),
                          width: 20.r,
                          height: 20.r,
                        ),
                      ),
                      buttonText: context.localization?.tryAgain,
                      appButtonModel: AppButtonStyles.primaryBordered,
                      onTap: widget.onTryAgain,
                    ),
                  ),
                  SizedBox(width: AppDimens.w16),
                  Expanded(
                    child: AppButton(
                      prefix: widget.visibleLoadingForLog
                          ? const AppLoadingButtonWidget(color: AppColors.white)
                          : null,
                      buttonText: widget.visibleLoadingForLog
                          ? ''
                          : context.localization?.logSelected,
                      appButtonModel: widget.logButtonEnabled
                          ? AppButtonStyles.primary
                          : AppButtonStyles.primary.copyWith(
                              decoration: AppButtonStyles.primary.decoration
                                  ?.copyWith(
                                      color: AppButtonStyles
                                          .primary.decoration?.color
                                          ?.withOpacity(0.4)),
                            ),
                      onTap:
                          widget.logButtonEnabled ? widget.onLogSelected : null,
                    ),
                  ),
                ],
              ),
              (context.bottomPadding + 16.h).verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
