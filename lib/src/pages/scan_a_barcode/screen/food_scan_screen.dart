import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_dimens.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/router/routes.dart';
import '../../../common/util/permission_manager_utility.dart';
import '../../../common/util/show_widget_util.dart';
import '../../../common/widgets/item_added_to_diary_widget.dart';
import '../../dashboard/dashboard_page.dart';
import '../bloc/food_scan_bloc.dart';
import '../dialog/added_to_diary_dialog.dart';
import '../dialog/intro_dialog.dart';
import '../sections/app_bar_section.dart';
import '../sections/camera_control_section.dart';
import '../sections/camera_frame_section.dart';
import '../sections/camera_section.dart';
import '../sections/result_section.dart';
import '../widgets/barcode_not_recognized_widget.dart';

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
  }

  @override
  void dispose() {
    _bloc?.add(const StopFoodDetectionEvent());
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
      body: BlocConsumer<FoodScanBloc, FoodScanState>(
        listener: (context, state) =>
            _handleStateChanges(context: context, state: state),
        buildWhen: (_, state) {
          return state is FoodScanInitial ||
              state is BarcodeNotRecognizedStateNew;
        },
        builder: (BuildContext context, FoodScanState state) {
          return Column(
            children: const [
              AppBarSection(),
              Expanded(
                child: Stack(
                  children: [
                    CameraSection(),
                    CameraFrameSection(),
                    // ScanningAnimationSection(),
                    CameraControlSection(),
                    ResultSection(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleStateChanges(
      {required BuildContext context, required FoodScanState state}) {
    if (state is IntroScreenVisibilityState) {
      _handleIntroVisibilityState(state);
    } else if (state is BarcodeNotRecognizedStateNew) {
      _showBarcodeNotRecognizedWidget(context, state.barcode);
    } else if (state is AddedToDiaryVisibilityState) {
      _handleAddedToDiaryVisibilityState(state);
    }
  }

  void _showBarcodeNotRecognizedWidget(BuildContext context, String? barcode) {
    ShowWidgetUtil.showCustomModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: AppColors.transparent,
      builder: (dsContext) {
        return BarcodeNotRecognizedWidget(
          onTapCancel: () {
            Navigator.pop(dsContext);
            _bloc?.add(const StartScanningEvent());
          },
          onTapTakePhoto: () async {
            Navigator.pop(dsContext);
            await Navigator.pushNamed(context, Routes.nutritionFacts,
                arguments: barcode);
            _bloc?.add(const StartScanningEvent());
          },
        );
      },
    );
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
      title: context.localization.permission,
      message: context.localization.cameraPermissionMessage,
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

  void _handleAddedToDiaryVisibilityState(AddedToDiaryVisibilityState state) {
    ShowWidgetUtil.showCustomGeneralDialog(
      context: context,
      builder: (_) {
        return ItemAddedToDiaryWidget(
          onTapNegative: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.dashboard,
                  (route) => route.isFirst,
              arguments: 1,
            );
          },
          onTapPositive: () {
            _bloc?.add(const StartScanningEvent());
          },
        );
      },
    );
    // AddedToDiaryDialog.show(
    //   context: context,
    //   onTapViewDiary: (dialogContext) {
    //     Navigator.pop(dialogContext);
    //     DashboardPage.navigate(
    //       context,
    //       page: 1,
    //       removeUntil: true,
    //     );
    //   },
    //   onTapContinue: (dialogContext) {
    //     Navigator.pop(dialogContext);
    //     _bloc?.add(const StartScanningEvent());
    //   },
    // );
  }
}
