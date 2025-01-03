import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_border.dart';
import '../../../../common/constant/app_colors.dart';
import '../../../../common/constant/app_padding.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/router/routes.dart';
import '../../../../common/widgets/app_bar/custom_app_bar.dart';
import '../../../../common/widgets/button/primary_button.dart';
import '../../../../common/widgets/passio/analyzing_progress_widget.dart';

class PhotoPreviewPage extends StatelessWidget {
  const PhotoPreviewPage({required this.image, super.key});

  final Uint8List image;

  static MaterialPageRoute route({required Uint8List image}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.photoPreview),
      builder: (_) => PhotoPreviewPage(image: image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: context.localization.photoPreview),
          16.verticalSpace,
          Expanded(
            flex: 2,
            child: ImagePreviewWidget(image: image),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: AppPadding.ph32,
                      child: AnalyzingProgressWidget(
                        text: context.localization.analyzingPhoto,
                        shouldFinish: false,
                      ),
                    ),
                  ),
                ),
                ActionButtonWidget(),
                (context.bottomPadding + 16).verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({required this.image});

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.ph32,
      child: ClipRRect(
        borderRadius: AppBorderCircular.ba8,
        child: Image.memory(
          image,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PrimaryButton(
          text: context.localization.cancel,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
