import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/models/macro/macros_model.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';

typedef OnSaveMacroTarget = Function();

class DailyMacroDialog {
  DailyMacroDialog.show({
    required BuildContext context,
    FixedExtentScrollController? carbsController,
    FixedExtentScrollController? proteinsController,
    FixedExtentScrollController? fatsController,
    List<int>? carbs,
    List<int>? proteins,
    List<int>? fats,
    required Macros macros,
    OnSaveMacroTarget? onSaveMacroTarget,
  }) {
    StateSetter? state;

    ({
      bool isCarbsScrolling,
      bool isProtienScrolling,
      bool isFatScrolling
    }) scrollingData = (
      isCarbsScrolling: false,
      isProtienScrolling: false,
      isFatScrolling: false
    );

    // Here waiting to render the frames.
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Carbs controller.
      carbsController?.position.isScrollingNotifier.addListener(() async {
        if (!carbsController.position.isScrollingNotifier.value) {
          // Scrolling is end
          if (scrollingData.isCarbsScrolling) {
            macros.carbsPercent = carbsController.selectedItem;
            await _updatePicker(
                proteinsController, proteins, macros, macros.proteinPercent);
            await _updatePicker(
                fatsController, fats, macros, macros.fatPercent);
            state?.call(() {});
          }
        }
      });
      // Protein controller.
      proteinsController?.position.isScrollingNotifier.addListener(() async {
        if (!proteinsController.position.isScrollingNotifier.value) {
          // Scrolling is end
          if (scrollingData.isProtienScrolling) {
            macros.proteinPercent = proteinsController.selectedItem;
            await _updatePicker(
                carbsController, carbs, macros, macros.carbsPercent);
            await _updatePicker(
                fatsController, fats, macros, macros.fatPercent);
            state?.call(() {});
          }
        }
      });

      // Fat controller.
      fatsController?.position.isScrollingNotifier.addListener(() async {
        if (!fatsController.position.isScrollingNotifier.value) {
          // Scrolling is end
          if (scrollingData.isFatScrolling) {
            macros.fatPercent = fatsController.selectedItem;
            await _updatePicker(
                carbsController, carbs, macros, macros.carbsPercent);
            await _updatePicker(
                proteinsController, proteins, macros, macros.proteinPercent);
            state?.call(() {});
          }
        }
      });
    });
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: Dimens.duration300),
      transitionBuilder: (context, a1, a2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(a1),
          child: child,
        );
      },
      pageBuilder: (context, animation, animation2) {
        return StatefulBuilder(builder: (context, setState) {
          state = setState;
          return Material(
            type: MaterialType.transparency,
            child: Align(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Dimens.w8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimens.r16),
                  ),
                  child: SizedBox.expand(
                    child: Column(
                      children: [
                        Dimens.h20.verticalSpace,
                        Text(
                          context.localization?.dailyMacroTarget ?? '',
                          style: AppStyles.style22,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Dimens.h20.verticalSpace,
                                  Text(
                                    context.localization?.carbs ?? '',
                                    style: AppStyles.style17,
                                  ),
                                  Dimens.h8.verticalSpace,
                                  Text(
                                    '${macros.carbsGram} g',
                                    style: AppStyles.style17.copyWith(
                                        color: AppColors.darkGreyColor),
                                  ),
                                  SizedBox(
                                    height: Dimens.h214,
                                    child: CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.22,
                                      scrollController: carbsController,
                                      selectionOverlay:
                                          const CupertinoPickerDefaultSelectionOverlay(
                                        capEndEdge: false,
                                      ),
                                      itemExtent: Dimens.r22,
                                      onSelectedItemChanged: (selectedItem) {
                                        scrollingData = (
                                          isCarbsScrolling: true,
                                          isProtienScrolling: false,
                                          isFatScrolling: false
                                        );
                                      },
                                      children: carbs
                                              ?.map((e) => Center(
                                                    child: Text(
                                                      '$e %',
                                                      style: AppStyles.style17,
                                                    ),
                                                  ))
                                              .toList() ??
                                          [],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Dimens.h20.verticalSpace,
                                  Text(
                                    context.localization?.protein ?? '',
                                    style: AppStyles.style17,
                                  ),
                                  Dimens.h8.verticalSpace,
                                  Text(
                                    '${macros.proteinGram} g',
                                    style: AppStyles.style17.copyWith(
                                        color: AppColors.darkGreyColor),
                                  ),
                                  SizedBox(
                                    height: Dimens.h214,
                                    child: CupertinoPicker(
                                      magnification: 1.22,
                                      scrollController: proteinsController,
                                      selectionOverlay:
                                          const CupertinoPickerDefaultSelectionOverlay(
                                        capStartEdge: false,
                                        capEndEdge: false,
                                      ),
                                      itemExtent: Dimens.r22,
                                      squeeze: 1.22,
                                      onSelectedItemChanged: (selectedItem) {
                                        scrollingData = (
                                          isCarbsScrolling: false,
                                          isProtienScrolling: true,
                                          isFatScrolling: false
                                        );
                                      },
                                      children: proteins
                                              ?.map((e) => Center(
                                                    child: Text(
                                                      '$e %',
                                                      style: AppStyles.style17,
                                                    ),
                                                  ))
                                              .toList() ??
                                          [],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Dimens.h20.verticalSpace,
                                  Text(
                                    context.localization?.fat ?? '',
                                    style: AppStyles.style17,
                                  ),
                                  Dimens.h8.verticalSpace,
                                  Text(
                                    '${macros.fatGrams} g',
                                    style: AppStyles.style17.copyWith(
                                        color: AppColors.darkGreyColor),
                                  ),
                                  SizedBox(
                                    height: Dimens.h214,
                                    child: CupertinoPicker(
                                      magnification: 1.22,
                                      scrollController: fatsController,
                                      selectionOverlay:
                                          const CupertinoPickerDefaultSelectionOverlay(
                                        capStartEdge: false,
                                      ),
                                      itemExtent: Dimens.r22,
                                      squeeze: 1.22,
                                      onSelectedItemChanged: (selectedItem) {
                                        scrollingData = (
                                          isCarbsScrolling: false,
                                          isProtienScrolling: false,
                                          isFatScrolling: true
                                        );
                                      },
                                      children: fats
                                              ?.map((e) => Center(
                                                    child: Text(
                                                      '$e %',
                                                      style: AppStyles.style17,
                                                    ),
                                                  ))
                                              .toList() ??
                                          [],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.h20),
                        Row(
                          children: [
                            SizedBox(width: Dimens.w16),
                            Expanded(
                              child: AppButton(
                                buttonName: context.localization?.cancel ?? '',
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                textStyle: AppStyles.style15
                                    .copyWith(color: AppColors.passioInset),
                              ),
                            ),
                            Dimens.w8.horizontalSpace,
                            Expanded(
                              child: AppButton(
                                buttonName: context.localization?.ok ?? '',
                                onTap: () {
                                  Navigator.pop(context);
                                  onSaveMacroTarget?.call();
                                },
                                textStyle: AppStyles.style15
                                    .copyWith(color: AppColors.passioInset),
                              ),
                            ),
                            SizedBox(width: Dimens.w16),
                          ],
                        ),
                        SizedBox(height: Dimens.h24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _updatePicker(FixedExtentScrollController? controller,
      List<int>? data, Macros macros, int percent) async {
    await controller?.animateToItem(
      data?.indexWhere((element) => element == percent) ?? 0,
      duration: const Duration(milliseconds: Dimens.duration300),
      curve: Curves.easeIn,
    );
  }
}
