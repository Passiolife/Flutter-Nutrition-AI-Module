import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/router/routes.dart';
import '../../../common/widgets/camera/camera_widget.dart';
import '../../../common/widgets/camera_frame_widget.dart';
import '../bloc/nutrition_facts_bloc.dart';
import '../widgets/camera_control_widget_new.dart';

class CameraSection extends StatefulWidget {
  const CameraSection({super.key});

  @override
  State<CameraSection> createState() => _CameraSectionState();
}

class _CameraSectionState extends State<CameraSection> {
  // // GlobalKey to uniquely identify the CameraWidget's state and access it
  final _cameraKey = GlobalKey<CameraWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraWidget(
          key: _cameraKey,
          resolution: ResolutionPreset.veryHigh,
        ),
        Positioned(
          top: 100.h,
          left: 24.w,
          right: 24.w,
          child: CameraFrameWidget(height: 380.h),
        ),
        BlocBuilder<NutritionFactsBloc, NutritionFactsState>(
          builder: (context, state) {
            return CameraControlWidget(
              onCapture: () {
                _takePicture(context: context);
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _takePicture({required BuildContext context}) async {
    final xFile =
        (await _cameraKey.currentState?.getController()?.takePicture());
    if (context.mounted) {
      // context.read<NutritionFactsBloc>().add(DoTakeImageEvent(file: xFile));
      Navigator.pushNamed(context, Routes.photoPreview, arguments: xFile);
    }
  }
}
