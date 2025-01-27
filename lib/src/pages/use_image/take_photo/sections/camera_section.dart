import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/router/routes.dart';
import '../bloc/take_photo_bloc.dart';
import '../models/take_photo_navigation_data_provider.dart';
import '../widgets/camera_control_widget.dart';
import '../../../../common/widgets/camera/camera_widget.dart';

class CameraSection extends StatefulWidget {
  const CameraSection({super.key});

  @override
  State<CameraSection> createState() => _CameraSectionState();
}

class _CameraSectionState extends State<CameraSection> {
  // // GlobalKey to uniquely identify the CameraWidget's state and access it
  final _cameraKey = GlobalKey<CameraWidgetState>();

  TakePhotoBloc? get _bloc => mounted ? context.read<TakePhotoBloc>() : null;

  @override
  Widget build(BuildContext context) {
    final navigationData = TakePhotoNavigationDataProvider.of(context);
    return Stack(
      children: [
        CameraWidget(
          key: _cameraKey,
          resolution: ResolutionPreset.veryHigh,
        ),
        BlocBuilder<TakePhotoBloc, TakePhotoState>(
          buildWhen: (_, state) {
            return state is TakePhotoSuccessListenerState ||
                state is RemovePhotoListenerState || state is TakePhotoInitialBuilderState;
          },
          builder: (context, state) {
            final images = (state is TakePhotoSuccessListenerState)
                ? state.images
                : (state is RemovePhotoListenerState)
                    ? state.images
                    : [];
            int length = images.length;
            return CameraControlWidget(
              onNegativeTap: () {
                Navigator.pop(context);
              },
              onCapture: () {
                _takePicture();
              },
              captureEnabled: length < navigationData.maxLimit,
              positiveEnabled: length > 0,
              onPositiveTap: () {
                if(navigationData.returnResult) {
                  Navigator.pop(context, images);
                  return;
                }
                Navigator.pushNamed(context, Routes.takePhotoResult, arguments: images);
                _bloc?.add(const InitialEvent());
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _takePicture() async {
    final xFile = await _cameraKey.currentState?.getController()?.takePicture();
    _bloc?.add(DoTakeImageEvent(file: xFile));
  }
}
