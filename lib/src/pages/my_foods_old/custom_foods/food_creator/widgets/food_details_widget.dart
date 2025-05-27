import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/widgets/app_pop_up_widget.dart';
import '../../../../../common/widgets/app_text_field.dart';
import '../../../../../common/widgets/custom_app_bar_widget.dart';
import '../../../../../common/widgets/passio_image_widget.dart';
import '../../../../use_image/select_photo/select_photo_page.dart';
import '../../../../use_image/take_photo/take_photo_page.dart';

typedef OnChangeFoodDetails = Function(
  Uint8List? image,
  String? name,
  String? brand,
);

typedef OnTapBarcode = VoidCallback;

class FoodDetailsWidget extends StatefulWidget {
  const FoodDetailsWidget({
    this.initialImage,
    this.initialIconId,
    this.initialName,
    this.initialBrand,
    this.initialBarcode,
    this.onChangeFoodDetails,
    this.onTapBarcode,
    super.key,
  });

  final Uint8List? initialImage;
  final String? initialIconId;
  final String? initialName;
  final String? initialBrand;
  final String? initialBarcode;
  final OnChangeFoodDetails? onChangeFoodDetails;
  final OnTapBarcode? onTapBarcode;

  @override
  State<FoodDetailsWidget> createState() => _FoodDetailsWidgetState();
}

class _FoodDetailsWidgetState extends State<FoodDetailsWidget> {
  Uint8List? _image;
  String? _iconId;
  String? _name;
  String? _brand;
  String? _barcode;

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage;
    _iconId = widget.initialIconId;
    _name = widget.initialName;
    _brand = widget.initialBrand;
    _barcode = widget.initialBarcode;
  }

  void _handleDetailsChange() {
    widget.onChangeFoodDetails?.call(_image, _name, _brand);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization.foodDetails ?? '',
            style: AppTextStyle.textBase.addAll([
              AppTextStyle.textBase.leading6,
              AppTextStyle.semiBold,
            ]).copyWith(color: AppColors.black),
          ),
          16.verticalSpace,
          Stack(
            children: [
              Row(
                children: [
                  EditImageWidget(
                    image: _image,
                    iconId: _iconId,
                    onChange: (image, name, brand) {
                      _image = image;
                      _handleDetailsChange();
                    },
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: _FormWidget(
                      initialName: _name,
                      initialBrand: _brand,
                      initialBarcode: _barcode,
                      onTapBarcode: widget.onTapBarcode,
                      onChange: (profile, name, brand) {
                        _name = name;
                        _brand = brand;
                        _handleDetailsChange();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditImageWidget extends StatefulWidget {
  const EditImageWidget({
    this.image,
    this.iconId,
    this.onChange,
    super.key,
  });

  final Uint8List? image;
  final String? iconId;
  final OnChangeFoodDetails? onChange;

  @override
  State<EditImageWidget> createState() => _EditImageWidgetState();
}

class _EditImageWidgetState extends State<EditImageWidget> {
  List<MenuModel> getMenu(BuildContext context) => [
        MenuModel(
          icon: AppImages.icCamera,
          title: context.localization.takePhoto,
        ),
        MenuModel(
          icon: AppImages.icViewGrid,
          title: context.localization.selectPhoto,
        ),
      ];

  final ValueNotifier<Uint8List?> _image = ValueNotifier(null);

  @override
  void initState() {
    _image.value = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPopupWidget<MenuModel>(
      items: getMenu(context),
      itemBuilder: (item) {
        return MenuItemRow(
          imagePath: item.icon,
          text: item.title,
        );
      },
      onSelected: (value) async {
        if (value.title == context.localization.takePhoto) {
          List<Uint8List>? profiles = await TakePhotoPage.navigate(context,
              returnResult: true, maxLimit: 1);
          if (profiles?.firstOrNull != null) {
            _image.value = profiles?.firstOrNull;
          }
        } else if (value.title == context.localization.selectPhoto) {
          List<Uint8List>? profiles = await SelectPhotoPage.navigate(context,
              returnResult: true, maxLimit: 1);
          if (profiles?.firstOrNull != null) {
            _image.value = profiles?.firstOrNull;
          }
        }
        if (_image.value != null) {
          widget.onChange?.call(_image.value, null, null);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
              valueListenable: _image,
              builder: (context, value, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: (widget.iconId?.isNotEmpty ?? false) ||
                          (value?.isNotEmpty ?? false)
                      ? PassioImageWidget(
                          key: ObjectKey([widget.iconId, value]),
                          iconId: widget.iconId ?? '',
                          image: value,
                        ) /*CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.r,
                          child: ClipOval(
                            child: Image.memory(
                              value,
                              width: 100.r,
                              height: 100.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )*/
                      : Image.asset(
                          AppImages.imgMyFoodsThumbnail,
                          width: 100.r,
                          height: 100.r,
                          fit: BoxFit.contain,
                        ),
                );
              }),
          8.verticalSpace,
          Text(
            context.localization.editImage ?? '',
            style: AppTextStyle.textSm
                .addAll([AppTextStyle.textSm.leading5]).copyWith(
              decoration: AppTextStyle.underline,
              decorationColor: AppColors.indigo600Main,
              color: AppColors.indigo600Main,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormWidget extends StatefulWidget {
  const _FormWidget({
    this.initialName,
    this.initialBrand,
    this.initialBarcode,
    this.onChange,
    this.onTapBarcode,
  });

  final String? initialName;
  final String? initialBrand;
  final String? initialBarcode;
  final OnChangeFoodDetails? onChange;
  final OnTapBarcode? onTapBarcode;

  @override
  State<_FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<_FormWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();

  void _setupListener(TextEditingController controller) {
    controller.addListener(() {
      widget.onChange?.call(
        null,
        nameController.text,
        brandController.text,
      );
    });
  }

  @override
  void initState() {
    nameController.text = widget.initialName ?? '';
    brandController.text = widget.initialBrand ?? '';
    barcodeController.text = widget.initialBarcode ?? '';

    _setupListener(nameController);
    _setupListener(brandController);

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FoodDetailField(
          title: context.localization.name,
          hintText: context.localization.enterName,
          controller: nameController,
          inputAction: TextInputAction.next,
          isMandatory: true,
        ),
        16.verticalSpace,
        _FoodDetailField(
          title: context.localization.brand,
          hintText: context.localization.enterBrand,
          controller: brandController,
        ),
        16.verticalSpace,
        _FoodDetailField(
          title: context.localization.barcode,
          hintText: context.localization.scanABarcode?.toLowerCase(),
          controller: barcodeController,
          onTap: widget.onTapBarcode,
          suffix: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: SvgPicture.asset(
              AppImages.icCamera,
              width: 24.r,
              height: 24.r,
              colorFilter: const ColorFilter.mode(
                AppColors.gray400,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FoodDetailField extends StatelessWidget {
  const _FoodDetailField({
    this.title,
    this.hintText,
    this.controller,
    this.inputAction,
    this.suffix,
    this.onTap,
    this.isMandatory = false,
  });

  final String? title;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputAction? inputAction;
  final Widget? suffix;
  final VoidCallback? onTap;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title ?? '',
                style: AppTextStyle.textSm.addAll([
                  AppTextStyle.textSm.leading5,
                  AppTextStyle.medium
                ]).copyWith(color: AppColors.gray500),
              ),
              if(isMandatory)
              TextSpan(
                text: ' *',
                style: AppTextStyle.textSm.addAll([
                  AppTextStyle.textSm.leading5,
                  AppTextStyle.medium
                ]).copyWith(color: AppColors.red500),
              ),
            ],
          ),
        ),
        4.verticalSpace,
        AppTextField(
            hintText: hintText,
            readOnly: onTap != null,
            onTap: onTap,
            controller: controller,
            hintStyle: AppTextStyle.textBase
                .addAll([AppTextStyle.textBase.leading6]).copyWith(
                    color: AppColors.gray500),
            style: AppTextStyle.textBase
                .addAll([AppTextStyle.textBase.leading6]).copyWith(
                    color: AppColors.gray900),
            inputAction: inputAction,
            suffixIcon: suffix,
            suffixIconConstraints:
                BoxConstraints(maxWidth: 40.r, maxHeight: 40.r),
            textCapitalization: TextCapitalization.sentences),
      ],
    );
  }
}
