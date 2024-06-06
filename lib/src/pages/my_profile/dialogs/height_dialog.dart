import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/action_buttons_widget.dart';

typedef OnSave = void Function(int unit, int subunit);

class HeightDialog {
  HeightDialog.show({
    required BuildContext context,
    String? title,
    MeasurementSystem? measurementSystem,
    int? initialUnit,
    int? initialSubunit,
    OnSave? onSaveHeight,
  }) {
    initialUnit ??= measurementSystem == MeasurementSystem.imperial ? 5 : 1;
    initialSubunit ??= measurementSystem == MeasurementSystem.imperial ? 6 : 10;

    final unit = measurementSystem == MeasurementSystem.imperial
        ? List.generate(9, (index) => "$index'")
        : List.generate(3, (index) => '$index m');

    final subunit = measurementSystem == MeasurementSystem.imperial
        ? List.generate(12, (index) => '$index"')
        : List.generate(100, (index) => '$index cm');

    final unitController =
        FixedExtentScrollController(initialItem: initialUnit);
    final subunitController =
        FixedExtentScrollController(initialItem: initialSubunit);

    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: false,
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
        return PopScope(
          canPop: false,
          child: StatefulBuilder(builder: (context, setState) {
            return Material(
              type: MaterialType.transparency,
              child: Align(
                alignment: Alignment.center,
                child: IntrinsicHeight(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: SizedBox.expand(
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            context.localization?.height ?? '',
                            style: AppTextStyle.textXl.addAll([
                              AppTextStyle.textXl.leading7,
                              AppTextStyle.bold
                            ]),
                          ),
                          SizedBox(
                            height: 214.h,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: CupertinoPicker(
                                    magnification: 1.22,
                                    squeeze: 1.2,
                                    itemExtent: 32.r,
                                    useMagnifier: true,
                                    scrollController: unitController,
                                    selectionOverlay:
                                        const CupertinoPickerDefaultSelectionOverlay(
                                            capEndEdge: false),
                                    onSelectedItemChanged: (selectedItem) {},
                                    children: unit
                                        .map((e) => Center(
                                                child: Text(
                                              e,
                                              style: AppTextStyle.textBase
                                                  .addAll([
                                                AppTextStyle.textBase.leading6
                                              ]),
                                            )))
                                        .toList(),
                                  ),
                                ),
                                Expanded(
                                  child: CupertinoPicker(
                                    magnification: 1.22,
                                    squeeze: 1.2,
                                    itemExtent: 32.r,
                                    useMagnifier: true,
                                    scrollController: subunitController,
                                    selectionOverlay:
                                        const CupertinoPickerDefaultSelectionOverlay(
                                            capStartEdge: false),
                                    onSelectedItemChanged: (selectedItem) {},
                                    children: subunit
                                        .map(
                                          (e) => Center(
                                            child: Text(
                                              e,
                                              style: AppTextStyle.textBase
                                                  .addAll([
                                                AppTextStyle.textBase.leading6
                                              ]),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ActionButtonsWidget(
                            cancelButtonText: context.localization?.cancel,
                            saveButtonText: context.localization?.save,
                            onTapCancel: () => Navigator.pop(context),
                            onTapSave: () {
                              onSaveHeight?.call(unitController.selectedItem,
                                  subunitController.selectedItem);
                              Navigator.pop(context);
                            },
                          ),
                          16.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
