import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/snackbar_extension.dart';

typedef OnModeChanged = Function(int mode);

class ScannerModeWidget extends StatelessWidget {
  ScannerModeWidget({this.initialMode, this.onModeChanged, super.key});

  final int? initialMode;
  final OnModeChanged? onModeChanged;

  // Initialize _selectedIcon with a static method to get the initial value
  late final ValueNotifier<String> _selectedIcon =
      ValueNotifier(_getInitialIcon());

  // Static method to get the initial icon
  String _getInitialIcon() {
    if (initialMode != null && initialMode! < _images.length) {
      return _images[initialMode!];
    } else {
      return _images.first;
    }
  }

  final List<String> _images = [
    AppImages.icFoods,
    AppImages.icBarcode,
    // AppImages.icNutritionFacts,
  ];

  List<String?> _getModeNames(BuildContext context) => [
        context.localization?.wholeFoodsMode?.replaceAll('\n', ''),
        context.localization?.barcodeMode?.replaceAll('\n', ''),
        // context.localization?.nutritionFactsMode?.replaceAll('\n', ''),
      ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16.h,
      left: 0,
      right: 0,
      child: ValueListenableBuilder(
          valueListenable: _selectedIcon,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _images
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: _ItemWidget(
                        image: e,
                        isSelected: value == e,
                        onModeChanged: (image) =>
                            _handleOnChange(context: context, image: image),
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
    );
  }

  void _handleOnChange({required BuildContext context, required String image}) {
    final index = _images.indexOf(image);
    _selectedIcon.value = image;
    onModeChanged?.call(index);
    context.showSnackbar(text: _getModeNames(context).elementAt(index));
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.image,
    this.isSelected = false,
    this.selectedColor = AppColors.indigo600Main,
    this.onModeChanged,
  });

  final String image;
  final bool isSelected;
  final Color selectedColor;
  final Function(String mode)? onModeChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.r,
      height: 40.r,
      child: ElevatedButton(
        onPressed: () {
          onModeChanged?.call(image);
        },
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          shape: const CircleBorder(),
          padding: EdgeInsets.all(8.r),
          backgroundColor:
              isSelected ? selectedColor : AppColors.white.withOpacity(0.4),
        ),
        child: Center(
          child: SvgPicture.asset(
            image,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
