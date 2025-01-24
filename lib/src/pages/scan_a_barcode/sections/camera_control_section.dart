import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/util/snackbar_extension.dart';
import '../bloc/food_scan_bloc.dart';
import '../widgets/camera_control_widget.dart';

class CameraControlSection extends StatelessWidget {
  const CameraControlSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodScanBloc, FoodScanState>(
      buildWhen: (_, state) {
        return state is FoodScanInitial || state is UpdatedCameraControlStateNew;
      },
      builder: (context, state) {
        double currentZoom = 1;
        double minZoom = 1;
        double maxZoom = 1;
        bool enabledFlashlight = false;
        if (state is UpdatedCameraControlStateNew) {
          currentZoom = state.currentZoom;
          minZoom = state.minZoom;
          maxZoom = state.maxZoom;
          enabledFlashlight = state.enabledFlashlight;
        }
        return Positioned(
          top: 414.h,
          left: 24.w,
          right: 24.w,
          child: CameraControlWidget(
            currentZoomLevel: currentZoom,
            minZoomLevel: minZoom,
            maxZoomLevel: maxZoom,
            onChanged: (value) => _onChanged(context: context, value: value),
            isFocusOn: false,
            onChangeFocus: () => _onChangeFocus(context: context),
            isFlashOn: enabledFlashlight,
            onChangeFlash: () => _onChangeFlash(context: context),
          ),
        );
      },
    );
  }

  void _onChanged({required BuildContext context, required double value}) {
    context
        .read<FoodScanBloc>()
        .add(DoUpdateCameraZoomLevelEvent(zoomLevel: value));
  }

  void _onChangeFocus({required BuildContext context}) {
    context.showSnackbar(text: 'Work is in progress.');
  }

  void _onChangeFlash({required BuildContext context}) {
    context.read<FoodScanBloc>().add(const DoToggleFlashEvent());
  }

}
