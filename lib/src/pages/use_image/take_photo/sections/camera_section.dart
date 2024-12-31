import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/take_photo_bloc.dart';
import '../models/take_photo_navigation_data_provider.dart';
import '../widgets/camera_control_widget.dart';
import '../widgets/camera_widget.dart';

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
                state is RemovePhotoListenerState;
          },
          builder: (context, state) {
            int length = (state is TakePhotoSuccessListenerState)
                ? state.images.length
                : (state is RemovePhotoListenerState)
                    ? state.images.length
                    : 0;
            return CameraControlWidget(
              onNegativeTap: () {
                Navigator.pop(context);
              },
              onCapture: () {
                _takePicture();
              },
              captureEnabled: length < navigationData.maxLimit,
              positiveEnabled: length > 0,
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
