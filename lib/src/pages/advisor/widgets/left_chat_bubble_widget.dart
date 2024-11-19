import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/advisor_chat/advisor_chat.dart';
import '../../../common/models/advisor_food_info_log/advisor_food_info_log.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_loading_button_widget.dart';
import '../../../common/widgets/food_item_row_widget.dart';
import '../../dashboard/dashboard_page.dart';

typedef SelectionChangeCallback = Function(
    int index, AdvisorFoodInfoLog advisorFoodInfoLog);

class LeftChatBubbleWidget extends StatelessWidget {
  const LeftChatBubbleWidget({
    required this.advisorChat,
    this.onTapFindFoods,
    this.onChangeSelection,
    this.onTapLog,
    super.key,
  });

  final AdvisorChat advisorChat;
  final VoidCallback? onTapFindFoods;
  final VoidCallback? onTapLog;
  final SelectionChangeCallback? onChangeSelection;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: 40.w),
        decoration: _buildContainerDecoration(),
        padding: EdgeInsets.all(8.r),
        child: _buildChildWidget(context),
      ),
    );
  }

  Decoration _buildContainerDecoration() {
    return AppShadows.base.copyWith(
      color: AppColors.indigo500Normal,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.r),
        topRight: Radius.circular(8.r),
        bottomLeft: const Radius.circular(0),
        bottomRight: Radius.circular(8.r),
      ),
    );
  }

  Widget _buildChildWidget(BuildContext context) {
    if (advisorChat.isLoading) {
      return AppLoadingButtonWidget(
        width: 24.w,
        height: 8.h,
        color: AppColors.white,
      );
    } else if (advisorChat.isAnalyzingLoading) {
      return const AnalysingLoadingWidget();
    } else if (advisorChat.advisorResponse != null) {
      return MarkDownResultWidget(
        advisorChat: advisorChat,
        onTapFindFoods: onTapFindFoods,
      );
    } else if (advisorChat.advisorFoodInfoLogs != null) {
      if (advisorChat.advisorFoodInfoLogs!.isNotEmpty) {
        return ResultWidget(
          advisorChat: advisorChat,
          onChangeSelection: onChangeSelection,
          onTapLog: onTapLog,
        );
      } else {
        return TextWidget(
          text: context.localization?.noResultsFound ?? '',
        );
      }
    } else {
      return TextWidget(
        text: advisorChat.message ?? '',
      );
    }
  }
}

class AnalysingLoadingWidget extends StatelessWidget {
  const AnalysingLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppLoadingButtonWidget(
          width: 33.w,
          height: 10.h,
          color: AppColors.white,
        ),
        8.horizontalSpace,
        Text(
          context.localization?.advisorIsAnalysing ?? '',
          style: AppTextStyle.textSm.addAll([AppTextStyle.italic]).copyWith(
              color: AppColors.white,
              height: AppTextStyle.calculateLineHeight(
                  20.h, AppTextStyle.textSm.fontSize ?? 14.sp)),
        ),
      ],
    );
  }
}

class MarkDownResultWidget extends StatelessWidget {
  const MarkDownResultWidget({
    required this.advisorChat,
    this.onTapFindFoods,
    super.key,
  });

  final AdvisorChat advisorChat;
  final VoidCallback? onTapFindFoods;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MarkDownWidget(
          text: advisorChat.advisorResponse?.markupContent ?? '',
        ),
        Visibility(
          visible: advisorChat.advisorResponse?.tools
                  ?.contains('SearchIngredientMatches') ??
              false,
          child: Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: IntrinsicWidth(
              child: AppButton(
                buttonText: context.localization?.findFoods,
                appButtonModel: AppButtonStyles.white,
                onTap: onTapFindFoods,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    required this.advisorChat,
    this.onChangeSelection,
    this.onTapLog,
    super.key,
  });

  final AdvisorChat advisorChat;
  final SelectionChangeCallback? onChangeSelection;
  final VoidCallback? onTapLog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          advisorChat.isFromFetchIngredients
              ? context.localization?.advisorIngredientsResultDescription ?? ''
              : context.localization?.advisorResultDescription ?? '',
          style: AppTextStyle.textSm.copyWith(
              color: AppColors.white,
              height: AppTextStyle.calculateLineHeight(
                  20.h, AppTextStyle.textSm.fontSize ?? 14.h)),
        ),
        20.verticalSpace,
        Column(
          children: advisorChat.advisorFoodInfoLogs
                  ?.asMap()
                  .entries
                  .map<Widget>((entry) {
                var index = entry.key;
                var data = entry.value;

                final advisorInfo = data.advisorFoodInfoModel;

                final foodDataInfo = advisorInfo?.foodDataInfo;
                final iconId = foodDataInfo?.iconID ?? '';
                final title = foodDataInfo?.foodName ?? '';
                final calories = foodDataInfo?.nutritionPreview.calories ?? 0;
                final weightQuantity =
                    foodDataInfo?.nutritionPreview.weightQuantity ?? 0;
                final caloriesPerGram = calories / weightQuantity;
                final weightGrams = advisorInfo?.weightGrams ?? 0;
                final caloriesForPortionSize = caloriesPerGram * weightGrams;
                final formattedWeightGrams = '${weightGrams.format()} ${context.localization?.g}';
                final subtitle =
                    '$formattedWeightGrams | ${caloriesForPortionSize.format()} ${context.localization?.cal}';

                final isSelected = data.isSelected;

                final isLogged = data.isLogged;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: FoodItemRowWidget.withSelection(
                    rippleColor: AppColors.indigo50,
                    iconId: iconId,
                    title: title,
                    subtitle: subtitle,
                    isAddVisible: false,
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                    decoration: BoxDecoration(color: isSelected ? AppColors.indigo50: null),
                    isSelected: isSelected,
                    suffix: isLogged != null
                        ? SvgPicture.asset(
                            isLogged ? AppImages.icCheck : AppImages.icUncheck,
                            width: 24.r,
                            height: 24.r,
                          )
                        : null,
                    onSelect: () => onChangeSelection?.call(index, data),
                    onTap: () => onChangeSelection?.call(index, data),
                  ),
                );
              }).toList() ??
              [],
        ),
        20.verticalSpace,
        advisorChat.isLogged
            ? AppButton(
                buttonText: context.localization?.viewDiary,
                appButtonModel: AppButtonStyles.white,
                onTap: () {
                  DashboardPage.navigate(
                    context,
                    page: 1,
                    removeUntil: true,
                  );
                },
              )
            : Row(
                children: [
                  /*Expanded(
                    child: AppButton(
                      buttonText: context.localization?.advisorCreateRecipe,
                      appButtonModel: AppButtonStyles.white,
                    ),
                  ),
                  16.horizontalSpace,*/
                  Expanded(
                    child: AppButton(
                      prefix: advisorChat.isLogLoading
                          ? const AppLoadingButtonWidget(
                              color: AppColors.indigo700)
                          : null,
                      buttonText: advisorChat.isLogLoading
                          ? ''
                          : context.localization?.logSelected,
                      appButtonModel:
                          advisorChat.advisorFoodInfoLogs?.hasSelectedItems() ??
                                  false
                              ? AppButtonStyles.white
                              : AppButtonStyles.white.copyWith(
                                  decoration: AppButtonStyles.white.decoration
                                      ?.copyWith(
                                          color: AppButtonStyles
                                              .white.decoration?.color
                                              ?.withOpacity(0.4)),
                                ),
                      onTap:
                          advisorChat.advisorFoodInfoLogs?.hasSelectedItems() ??
                                  false
                              ? onTapLog
                              : null,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

class MarkDownWidget extends StatelessWidget {
  const MarkDownWidget({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      // data: advisorChat.advisorResponse?.markupContent ?? '',
      data: text,
      shrinkWrap: true,
      styleSheet: MarkdownStyleSheet(
        h1: AppTextStyle.textSm.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textLg.fontSize ?? 18),
        ),
        h2: AppTextStyle.textSm.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textBase.fontSize ?? 16),
        ),
        h3: AppTextStyle.textSm.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        h4: AppTextStyle.textXs.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 12),
        ),
        h5: AppTextStyle.textXs.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        h6: AppTextStyle.textXs.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        p: AppTextStyle.textSm.copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        listBullet: AppTextStyle.textSm.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        checkbox: AppTextStyle.textSm.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        strong: AppTextStyle.textSm.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        em: AppTextStyle.textSm.copyWith(
          color: AppColors.white,
          fontStyle: FontStyle.italic,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        blockquote: AppTextStyle.textSm.copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        code: AppTextStyle.textSm.copyWith(
          color: AppColors.white,
          backgroundColor: AppColors.gray300,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        codeblockDecoration: const BoxDecoration(color: AppColors.gray300),
        tableHead: AppTextStyle.textSm.addAll([AppTextStyle.bold]).copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        tableBody: AppTextStyle.textSm.copyWith(
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 14),
        ),
        horizontalRuleDecoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.white,
              width: 1.0,
            ),
          ),
        ),
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
          color: AppColors.white,
          height: AppTextStyle.calculateLineHeight(
              20.h, AppTextStyle.textSm.fontSize ?? 0)),
    );
  }
}
