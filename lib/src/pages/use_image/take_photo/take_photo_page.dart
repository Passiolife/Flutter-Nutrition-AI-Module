import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/router/routes.dart';
import '../../../common/util/show_widget_util.dart';
import 'bloc/take_photo_bloc.dart';
import 'models/take_photo_navigation_data_provider.dart';
import 'sections/camera_frame_section.dart';
import 'sections/camera_section.dart';
import 'sections/captured_images_section.dart';
import 'sections/take_photo_header_section.dart';
import 'widgets/intro_widget.dart';

part 'screen/take_photo_screen.dart';

class TakePhotoPage extends StatelessWidget {
  const TakePhotoPage({
    required this.returnResult,
    required this.maxLimit,
    super.key,
  });

  final bool returnResult;

  // Maximum number of images allowed to be stored
  final int maxLimit;

  static MaterialPageRoute route({
    required bool returnResult,
    required int maxLimit,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.takePhoto),
      builder: (_) => TakePhotoPage(
        returnResult: returnResult,
        maxLimit: maxLimit,
      ),
    );
  }

  static Future navigate(BuildContext context,
      {bool returnResult = false, int maxLimit = 7}) async {
    return await Navigator.pushNamed(
      context,
      Routes.takePhoto,
      arguments: [returnResult, maxLimit],
    );
  }

  @override
  Widget build(BuildContext context) {
    return TakePhotoNavigationDataProvider(
      returnResult: returnResult,
      maxLimit: maxLimit,
      child: BlocProvider(
        create: (context) => TakePhotoBloc(),
        child: _TakePhotoScreen(),
      ),
    );
  }
}
