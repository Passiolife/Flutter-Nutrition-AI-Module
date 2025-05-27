import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/widgets/edit_image_widget_new.dart';
import '../../../common/widgets/icons/barcode_scan_icon.dart';
import '../../../common/widgets/text_input/primary_text_input.dart';

class FoodDetailsWidget extends StatelessWidget {
  const FoodDetailsWidget({
    this.index,
    this.iconId,
    this.image,
    this.onImageChanged,
    this.initialNameValue,
    this.onNameChanged,
    this.initialBrandValue,
    this.onBrandChanged,
    this.initialBarcodeValue,
    this.onTapBarcode,
    super.key,
  });

  final int? index;

  // Image
  final String? iconId;
  final Uint8List? image;
  final OnChangeImage? onImageChanged;

  // Name
  final String? initialNameValue;
  final void Function(String)? onNameChanged;

  // Brand
  final String? initialBrandValue;
  final void Function(String)? onBrandChanged;

  // Barcode
  final String? initialBarcodeValue;
  final void Function()? onTapBarcode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: AppPadding.pa16,
      margin: AppPadding.pt16 + AppPadding.ph16 + AppPadding.pb8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            context.localization.foodDetails,
            style: AppTextStyle.textBase.addAll([
              AppTextStyle.textBase.leading6,
              AppTextStyle.semiBold,
            ]).copyWith(color: AppColors.black),
          ),
          16.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EditImageWidget(
                defaultImage: AppImages.icCustomFoods,
                image: image,
                iconId: iconId,
                onChange: onImageChanged,
                index: index,
              ),
              16.horizontalSpace,
              Expanded(
                child: _FoodDetailsForm(
                  nameInitialValue: initialNameValue,
                  onNameChanged: onNameChanged,
                  brandInitialValue: initialBrandValue,
                  onBrandChanged: onBrandChanged,
                  barcodeInitialValue: initialBarcodeValue,
                  onTapBarcode: onTapBarcode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FoodDetailsForm extends StatefulWidget {
  const _FoodDetailsForm({
    required this.nameInitialValue,
    this.onNameChanged,
    this.brandInitialValue,
    this.onBrandChanged,
    this.barcodeInitialValue,
    this.onTapBarcode,
  });

  // Name
  final String? nameInitialValue;
  final void Function(String)? onNameChanged;

  // Brand
  final String? brandInitialValue;
  final void Function(String)? onBrandChanged;

  // Barcode
  final String? barcodeInitialValue;
  final void Function()? onTapBarcode;

  @override
  State<_FoodDetailsForm> createState() => _FoodDetailsFormState();
}

class _FoodDetailsFormState extends State<_FoodDetailsForm> {

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _barcodeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.nameInitialValue ?? '');
    _brandController = TextEditingController(text: widget.brandInitialValue ?? '');
    _barcodeController = TextEditingController(text: widget.barcodeInitialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant _FoodDetailsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.nameInitialValue != widget.nameInitialValue) {
        _nameController.text = widget.nameInitialValue ?? '';
      }
      if (oldWidget.brandInitialValue != widget.brandInitialValue) {
        _brandController.text = widget.brandInitialValue ?? '';
      }
      if (oldWidget.barcodeInitialValue != widget.barcodeInitialValue) {
        _barcodeController.text = widget.barcodeInitialValue ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PrimaryTextInput(
          hintText: context.localization.enterName,
          controller: _nameController,
          labelText: context.localization.name,
          onChanged: widget.onNameChanged,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return '';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
        ),
        16.verticalSpace,
        PrimaryTextInput(
          hintText: context.localization.enterBrand,
          controller: _brandController,
          labelText: context.localization.brand,
          onChanged: widget.onBrandChanged,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
        ),
        16.verticalSpace,
        PrimaryTextInput(
          hintText: context.localization.scanABarcode.toLowerCase(),
          controller: _barcodeController,
          labelText: context.localization.barcode,
          onTap: widget.onTapBarcode,
          readOnly: true,
          suffix: UnconstrainedBox(child: BarcodeScanIcon()),
        ),
      ],
    );
  }
}
