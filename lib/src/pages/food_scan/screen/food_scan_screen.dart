import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_dimens.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/permission_manager_utility.dart';
import '../../../common/util/show_widget_util.dart';
import '../bloc/food_scan_bloc.dart';
import '../dialog/intro_dialog.dart';
import '../sections/app_bar_section.dart';
import '../sections/camera_frame_section.dart';
import '../sections/camera_section.dart';
import '../sections/camera_control_section.dart';
import '../sections/result_section.dart';
import '../widgets/barcode_not_recognized_widget.dart';
import '../widgets/scanning_animation_widget_new.dart';

class FoodScanScreen extends StatefulWidget {
  const FoodScanScreen({super.key});

  @override
  State<FoodScanScreen> createState() => _FoodScanScreenState();
}

class _FoodScanScreenState extends State<FoodScanScreen> {
  late final FoodScanBloc? _bloc =
      context.mounted ? context.read<FoodScanBloc>() : null;

  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  // Instance of PermissionManagerUtility to handle permissions
  final PermissionManagerUtility _permissionManager =
      PermissionManagerUtility();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
    super.initState();
  }

  void _initialize() {
    // Create an AppLifecycleListener to listen for changes in the app lifecycle
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        // Call permission manager to handle app lifecycle state change
        _permissionManager.didChangeAppLifecycleState(state);
      },
    );

    _bloc?.add(const IntroScreenEvent());

    /*ShowWidgetUtil.showCustomModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (_) {
        return BarcodeNotRecognizedWidget();
      },
    );*/
  }

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color
      backgroundColor: AppColors.gray50,
      // Prevent the screen from resizing when the keyboard is shown
      resizeToAvoidBottomInset: false,
      body: BlocListener<FoodScanBloc, FoodScanState>(
        // bloc: _bloc,
        listener: (context, state) =>
            _handleStateChanges(context: context, state: state),
        /*buildWhen: (_, state) =>
        state is! ScanningAnimationState &&
            state is! ConversionSuccessState,*/
        child: Column(
          children: [
            const AppBarSection(),
            Expanded(
              child: Stack(
                children: [
                  const CameraSection(),
                  const CameraFrameSection(),
                  const ScanningAnimationWidget(),
                  const CameraControlSection(),
                  const ResultSection(),
                ],
              ),
            ),

            // Expanded(
            //   child: Stack(
            //     fit: StackFit.expand,
            //     children: [
            //       _showPassioPreview
            //           ? const PassioPreview()
            //           : Container(color: AppColors.black),
            //       GestureDetector(
            //         behavior: HitTestBehavior.opaque,
            //         onTap: state is ScanResultState
            //             ? () =>
            //             _bottomBackgroundWidgetKey.currentState
            //                 ?.setInitialHeight()
            //             : null,
            //         child:
            //         ScanningAnimationWidget(key: _scanningAnimationKey),
            //       ),
            //       Positioned(
            //         top: 500.h,
            //         left: 24.w,
            //         right: 24.w,
            //         child: CameraZoomFocusWidget(
            //           currentZoomLevel: _currentZoom,
            //           minZoomLevel: _cameraZoomLevel?.minZoomLevel ?? 1,
            //           maxZoomLevel: _cameraZoomLevel?.maxZoomLevel ?? 10,
            //           onChanged: (value) {
            //             _bloc.add(
            //                 DoUpdateCameraZoomLevelEvent(zoomLevel: value));
            //           },
            //           isFocusOn: false,
            //           onChangeFocus: () {
            //             context.showSnackbar(text: 'Work is in progress.');
            //           },
            //         ),
            //       ),
            //       (state is ScanLoadingState ||
            //           state is ScanResultState ||
            //           state is NutritionFactsResultState)
            //           ? DraggableBottomSheetWidget(
            //         key: ObjectKey(state is ScanResultState
            //             ? state.foodItem
            //             : true),
            //         initialSize: _initialSheetSize,
            //         minSize: _initialSheetSize,
            //         maxSize: _maxSheetSize,
            //         shouldDraggable: _sheetDraggable,
            //         builder: (context, dragController, controller,
            //             widgetState) {
            //           return state is ScanResultState ||
            //               state is NutritionFactsResultState
            //               ? _currentMode == 2
            //               ? NutritionFactsResultWidget(
            //             nutritionFacts: _nutritionFacts,
            //             isLoadingNext: state
            //             is NutritionFactsLoadingNextState,
            //             isEnableNext: _nutritionFacts != null,
            //             handler: this,
            //           )
            //               : ResultWidget(
            //             dragController: dragController,
            //             scrollController: controller,
            //             widgetState: widgetState,
            //             iconId: _foodItem?.iconId ??
            //                 _detectedCandidate?.passioID ??
            //                 '',
            //             foodName: _foodItem?.name ??
            //                 _detectedCandidate?.foodName ??
            //                 '',
            //             alternatives: _alternatives,
            //             listener: this,
            //             shouldDraggable: _sheetDraggable,
            //             visibleDragIntro: !Settings.instance
            //                 .getDragIntroSeen(),
            //           )
            //               : const ScanningWidget();
            //         },
            //       )
            //           : const SizedBox.shrink(),
            //       ScannerModeWidget(
            //         initialMode: _currentMode,
            //         onModeChanged: (mode) {
            //           _bottomBackgroundWidgetKey.currentState
            //               ?.setMaxSizeWithInitialInPixels(
            //               _bottomBackgroundWidgetKey.currentState
            //                   ?.getInitialSizePixels() ??
            //                   0);
            //           _currentMode = mode;
            //           _bloc.add(DoModeChangeEvent(mode: _currentMode ?? 0));
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _handleStateChanges(
      {required BuildContext context, required FoodScanState state}) {
    if (state is IntroScreenVisibilityState) {
      _handleIntroVisibilityState(state);
    } else if (state is BarcodeNotRecognizedState) {
      ShowWidgetUtil.showCustomModalBottomSheet(
        context: context,
        builder: (_) {
          return BarcodeNotRecognizedWidget();
        },
      );
    }
  }

  // Handle intro screen visibility
  void _handleIntroVisibilityState(IntroScreenVisibilityState state) {
    if (state.shouldVisible) {
      IntroDialog.show(
        context: context,
        onTapOk: (context) {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: AppDimens.duration250),
              () {
            _checkPermission();
            _bloc?.add(const IntroScreenCompleteEvent());
          });
        },
      );
    } else {
      // Check for permissions
      _checkPermission();
    }
  }

  // Check camera permission
  Future _checkPermission() async {
    await PermissionManagerUtility().request(
      context,
      Permission.camera,
      title: context.localization?.permission,
      message: context.localization?.cameraPermissionMessage,
      onTapCancelForSettings: (contextPermission) {
        Navigator.pop(contextPermission);
        Navigator.pop(context);
      },
      onUpdateStatus: (Permission? permission) async {
        if ((await permission?.isGranted) ?? false) {
          _bloc?.add(const StartScanningEvent());
        }
      },
    );
  }
}
