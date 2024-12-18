import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_images.dart';
import '../../../common/util/context_extension.dart';

class ListeningWaveWidget extends StatelessWidget {
  const ListeningWaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.wave,
      width: context.width,
      height: 100.h,
      fit: BoxFit.cover,
    );
  }
}
