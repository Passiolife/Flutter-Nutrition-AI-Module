import 'package:flutter/material.dart';

import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/widgets/app_bar/custom_app_bar.dart';

class TakePhotoAppBar extends StatelessWidget {
  const TakePhotoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: context.localization?.yourResults ?? '',
    );
  }
}
