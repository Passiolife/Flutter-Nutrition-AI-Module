import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';

typedef OnSaveHeight = Function(int meter, int centimeter);

class HeightDialog {
  HeightDialog.show({
    required BuildContext context,
    String? title,
    FixedExtentScrollController? meterController,
    FixedExtentScrollController? centimeterController,
    List<String>? meter,
    List<String>? centimeter,
    OnSaveHeight? onSaveHeight,
  }) {
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
      pageBuilder: (dialogContext, animation, animation2) {
        return StatefulBuilder(builder: (builderContext, setState) {
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
                        SizedBox(height: Dimens.h20),
                        Text(
                          title ?? '',
                          style: AppStyles.style22,
                        ),
                        SizedBox(
                          height: Dimens.h214,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: CupertinoPicker(
                                  magnification: 1.22,
                                  scrollController: meterController,
                                  selectionOverlay:
                                      const CupertinoPickerDefaultSelectionOverlay(
                                    capEndEdge: false,
                                  ),
                                  itemExtent: Dimens.r22,
                                  onSelectedItemChanged: (selectedItem) {},
                                  squeeze: 1.22,
                                  children: meter
                                          ?.map((e) => Center(
                                              child: Text(e,
                                                  style: AppStyles.style17)))
                                          .toList() ??
                                      [],
                                ),
                              ),
                              Expanded(
                                child: CupertinoPicker(
                                  magnification: 1.22,
                                  scrollController: centimeterController,
                                  selectionOverlay:
                                      const CupertinoPickerDefaultSelectionOverlay(
                                    capStartEdge: false,
                                  ),
                                  itemExtent: Dimens.r22,
                                  onSelectedItemChanged: (selectedItem) {},
                                  squeeze: 1.22,
                                  children: centimeter
                                          ?.map((e) => Center(
                                              child: Text(e,
                                                  style: AppStyles.style17)))
                                          .toList() ??
                                      [],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: Dimens.w16),
                            Expanded(
                              child: AppButton(
                                buttonName: context.localization?.cancel ?? '',
                                textStyle: AppStyles.style15
                                    .copyWith(color: AppColors.passioInset),
                                onTap: () {
                                  Navigator.pop(dialogContext);
                                },
                              ),
                            ),
                            SizedBox(width: Dimens.w8),
                            Expanded(
                              child: AppButton(
                                buttonName: context.localization?.ok ?? '',
                                textStyle: AppStyles.style15
                                    .copyWith(color: AppColors.passioInset),
                                onTap: () {
                                  onSaveHeight?.call(
                                      meterController?.selectedItem ?? 0,
                                      centimeterController?.selectedItem ?? 0);
                                  Navigator.pop(dialogContext);
                                },
                              ),
                            ),
                            SizedBox(width: Dimens.w16),
                          ],
                        ),
                        SizedBox(height: Dimens.h20),
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
}
