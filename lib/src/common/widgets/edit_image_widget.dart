import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../pages/use_image/select_photo/select_photo_page.dart';
import '../../pages/use_image/take_photo/take_photo_page.dart';
import '../constant/app_constants.dart';
import '../models/menu_model/menu_model.dart';
import '../extension/context_extension.dart';
import '../widgets/menu_item_row_widget.dart';
import 'app_pop_up_widget.dart';
import 'passio_image_widget.dart';
import 'vector/vector_widget.dart';

typedef OnChangeImage = void Function(Uint8List? image);

class EditImageWidget extends StatefulWidget {
  const EditImageWidget({
    required this.defaultImage,
    this.iconId,
    this.image,
    this.onChange,
    super.key,
  });

  final String defaultImage;
  final String? iconId;
  final Uint8List? image;
  final OnChangeImage? onChange;

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
          widget.onChange?.call(_image.value);
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
                  child: widget.iconId != null || value != null
                      ? PassioImageWidget(
                          key: ObjectKey([widget.iconId, value]),
                          iconId: widget.iconId ?? '',
                          image: value,
                          radius: 50.r,
                        )
                      : Image.asset(
                          widget.defaultImage,
                          width: 100.r,
                          height: 100.r,
                          fit: BoxFit.contain,
                        ),
                  /*VectorWidget(
                    imagePath: widget.defaultImage,
                    width: 100.r,
                    height: 100.r,
                  ),*/
                );
              }),
          8.verticalSpace,
          Text(
            context.localization.editImage,
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
