import 'package:flutter/material.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/passio_image_widget.dart';
import 'interfaces.dart';
import 'typedefs.dart';

typedef OnResultSheetDrag = Function(bool isCollapsed);

class ResultWidget extends StatefulWidget {
  const ResultWidget({
    super.key,
    required this.iconId,
    this.foodName,
    this.foodSize,
    this.foodCalories,
    this.alternatives = const [],
    this.onFoodLog,
    this.listener,
    this.shouldDraggable = true,
    this.visibleDragIntro = true,
  });

  final String iconId;
  final String? foodName;
  final String? foodSize;
  final String? foodCalories;
  final OnFoodLog? onFoodLog;
  final List<DetectedCandidate> alternatives;

  final bool shouldDraggable;
  final bool visibleDragIntro;
  final FoodScanListener? listener;

  @override
  State<ResultWidget> createState() => ResultWidgetState();
}

class ResultWidgetState extends State<ResultWidget> {
  final GlobalKey _contentKey = GlobalKey();

  double get _initialSize =>
      (widget.shouldDraggable && widget.visibleDragIntro) ? 0.32 : 0.25;
  final double _maxSize = 0.6;

  final DraggableScrollableController _scrollableController =
      DraggableScrollableController();

  final ValueNotifier<double> _draggedHeight = ValueNotifier(0);

  @override
  void initState() {
    _scrollableController.addListener(() {
      widget.listener?.onDragResult(_scrollableController.size == _initialSize);
      _draggedHeight.value = getDraggedPixels();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      shouldCloseOnMinExtent: false,
      minChildSize: _initialSize,
      initialChildSize: _initialSize,
      maxChildSize: widget.shouldDraggable ? _maxSize : _initialSize,
      controller: _scrollableController,
      builder: (context, controller) {
        return Container(
          key: _contentKey,
          width: context.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimens.r16),
              topRight: Radius.circular(AppDimens.r16),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
          child: Column(
            children: [
              SizedBox(height: AppDimens.h8),
              widget.shouldDraggable
                  ? SingleChildScrollView(
                      controller: controller,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            width: AppDimens.w48,
                            height: AppDimens.h4,
                            decoration: BoxDecoration(
                              color: AppColors.gray200,
                              borderRadius:
                                  BorderRadius.circular(AppDimens.r24),
                            ),
                          ),
                          widget.visibleDragIntro
                              ? Padding(
                                  padding: EdgeInsets.only(top: AppDimens.h16),
                                  child: Text(
                                    context.localization
                                            ?.scanResultsDescription ??
                                        '',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.textSm
                                        .copyWith(color: AppColors.gray900),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  physics: widget.shouldDraggable
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: AppDimens.h24),
                      Row(
                        children: [
                          PassioImageWidget(
                            iconId: widget.iconId,
                            radius: AppDimens.r20,
                          ),
                          SizedBox(width: AppDimens.w16),
                          Expanded(
                            child: Text(
                              widget.foodName?.toUpperCaseWord ?? '',
                              style: AppTextStyle.textSm.addAll([
                                AppTextStyle.textSm.leading6,
                                AppTextStyle.bold
                              ]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: widget.shouldDraggable,
                        maintainAnimation: false,
                        maintainState: false,
                        maintainSize: false,
                        child: Padding(
                          padding: EdgeInsets.only(top: AppDimens.h24),
                          child: ValueListenableBuilder<double>(
                            valueListenable: _draggedHeight,
                            builder: (context, value, child) {
                              return value > 0
                                  ? child ?? const SizedBox.shrink()
                                  : const SizedBox.shrink();
                            },
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.alternatives.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _AlternativeRow(candidate: widget.alternatives.elementAt(index));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(height: AppDimens.h8);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: AppDimens.duration250),
                child: ValueListenableBuilder<double>(
                  valueListenable: _draggedHeight,
                  builder: (context, value, child) {
                    return (value > AppDimens.h100)
                        ? child ?? const SizedBox.shrink()
                        : const SizedBox.shrink();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: AppDimens.h24),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: RichText(
                        text: TextSpan(
                          text:
                              '${context.localization?.notWhatYouAreLookingFor} ',
                          style: AppTextStyle.textSm
                              .addAll([AppTextStyle.textSm.leading5]),
                          children: [
                            TextSpan(
                              text: context.localization?.searchManually,
                              style: AppTextStyle.textSm.addAll([
                                AppTextStyle.textSm.leading5,
                                AppTextStyle.bold
                              ]).copyWith(color: AppColors.blue600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppDimens.h24),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonText: context.localization?.edit,
                      appButtonModel: AppButtonStyles.primaryBordered,
                      // onTap: onTapEdit,
                    ),
                  ),
                  SizedBox(width: AppDimens.w16),
                  Expanded(
                    child: AppButton(
                      buttonText: context.localization?.log,
                      appButtonModel: AppButtonStyles.primary,
                      onTap: () => widget.onFoodLog?.call(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimens.h40),
            ],
          ),
        );
      },
    );
  }

  void setInitialHeight() {
    _scrollableController.animateTo(
      _initialSize,
      duration: const Duration(milliseconds: AppDimens.duration400),
      curve: Curves.ease,
    );
  }

  double getDraggedPixels() {
    return _scrollableController.isAttached
        ? _scrollableController.sizeToPixels(
            (_scrollableController.size >= _maxSize)
                ? 0.59
                : _scrollableController.size - _initialSize)
        : 0;
  }
}

class _AlternativeRow extends StatelessWidget {
  const _AlternativeRow({required this.candidate});

  final DetectedCandidate candidate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.indigo50,
        borderRadius: BorderRadius.circular(AppDimens.r4),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: Image.asset(AppImages.demo1),
        title: Text(
          candidate.foodName,
          style: AppTextStyle.textSm.addAll([
            AppTextStyle.textSm.leading5,
            AppTextStyle.semiBold
          ]).copyWith(color: AppColors.gray900),
        ),
        /*subtitle: Text(
          'Apples, raw, fuji, with skin',
          style: AppTextStyle.textSm.addAll([
            AppTextStyle.textSm.leading5,
          ]).copyWith(color: AppColors.gray700),
        ),*/
      ),
    );
  }
}
