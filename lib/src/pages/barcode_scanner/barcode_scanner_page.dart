import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../common/constant/app_constants.dart';
import '../../common/extension/context_extension.dart';
import '../../common/permission_manager/permission_manager.dart';
import '../../common/router/routes.dart';
import '../../common/util/show_widget_util.dart';
import '../../common/widgets/app_bar/custom_app_bar.dart';
import '../edit_food/ui/edit_food_page.dart';
import '../my_foods/custom_foods/food_creator/food_creator_page.dart';
import 'bloc/barcode_scanner_bloc.dart';
import 'dialogs/barcode_dialog.dart';
import 'sections/camera_section.dart';
import 'widgets/barcode_in_system_widget.dart';
import 'widgets/custom_food_already_exists_widget.dart';
import 'widgets/widgets.dart';

part 'screen/barcode_scanner_screen.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute<String>(
        builder: (_) => const BarcodeScannerPage());
  }

  static Future navigate({required BuildContext context}) async {
    return await Navigator.pushNamed(
      context,
      Routes.barcodeScanner,
    );
  }

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final _bloc = BarcodeScannerBloc();

  // Instance of PermissionManagerUtility to handle permissions
  // final _permissionManager = PermissionManagerUtility();

  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  // This flag controls the visibility of the Passio preview,
  // ensuring it's only shown after the screen has rendered to provide a smoother navigation experience.
  bool _showPassioPreview = false;

  // final _scanningAnimationKey = GlobalKey<ScanningAnimationWidgetState>();

  bool _visibleDialog = false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.add(const StopFoodDetectionEvent());
    _lifecycleListener?.dispose();
    _bloc.close();
    super.dispose();
  }

  void _initialize() {
    // Create an AppLifecycleListener to listen for changes in the app lifecycle
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        // Call permission manager to handle app lifecycle state change
        // _permissionManager.didChangeAppLifecycleState(state);
      },
    );

    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BarcodeScannerBloc(),
      child: const _BarcodeScannerScreen(),
    );
    return BlocConsumer<BarcodeScannerBloc, BarcodeScannerState>(
      bloc: _bloc,
      listener: _handleStateChanges,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          body: Column(
            children: [
              CustomAppBarWidget(
                title: context.localization.barcodeScanner,
                isMenuVisible: false,
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _showPassioPreview
                        ? const PassioPreview()
                        : Container(color: AppColors.black),
                    // TODO: Handle animation
                    /*AnimatedOpacity(
                      opacity: _visibleDialog ? 0 : 1,
                      duration: const Duration(milliseconds: 250),
                      child:
                          ScanningAnimationWidget(key: _scanningAnimationKey),
                    ),*/
                    Positioned(
                      top: 110.h + 380.h,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _visibleDialog ? 0 : 1,
                        duration: const Duration(milliseconds: 250),
                        child: const TutorialWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Check camera permission
  Future _checkPermission() async {
    // await PermissionManagerUtility().request(
    //   context,
    //   Permission.camera,
    //   title: context.localization.permission,
    //   message: context.localization.cameraPermissionMessage,
    //   onTapCancelForSettings: (contextPermission) {
    //     Navigator.pop(contextPermission);
    //     Navigator.pop(context);
    //   },
    //   onUpdateStatus: (Permission? permission) async {
    //     if ((await permission?.isGranted) ?? false) {
    //       _startScanning();
    //     }
    //   },
    // );
  }

  void _startScanning() {
    _bloc.add(const StartScanningEvent());
  }

  void _handleStateChanges(BuildContext context, BarcodeScannerState state) {
    if (state is ListenerState) {
      switch (state) {
        // case ScanningListenerState():
        //   _handleScanningState(state);
        //   break;
        case CustomFoodRecordFoundListenerState():
          _visibleDialog = true;
          _showBarcodeDialog(
            context: context,
            title: context.localization.customFoodAlreadyExists,
            description:
            context.localization.customFoodAlreadyExistsDescription,
            foodRecord: state.foodRecord,
            customFoodButtonText:
            context.localization.createCustomFoodWithoutBarcode,
            fromCustomFood: true,
          );
          break;
        case SystemFoodRecordFoundListenerState():
          _visibleDialog = true;
          _showBarcodeDialog(
            context: context,
            foodRecord: state.foodRecord,
            title: context.localization.barcodeInSystem,
            description: context.localization.barcodeInSystemDescription,
            customFoodButtonText: context.localization.createCustomFoodAnyway,
            barcode: state.barcode,
          );
          break;
        case UnknownBarcodeFoundListenerState():
          Navigator.pop(
            context,
            state.barcode,
          );
          break;
        // case ScanningAnimationBuilderListenerState():
        //   _handleScanningAnimationState(state.shouldAnimate);
        //   break;
      }
    }
  }

  // Handle scanning animation
  // void _handleScanningState(ScanningListenerState state) {
  //   if (!_showPassioPreview) {
  //     _showPassioPreview = true;
  //   }
  //   _handleScanningAnimationState(true);
  // }

  // Handle scan result visibility
  void _handleScanningAnimationState(bool shouldStart) {
    // if (shouldStart) {
    //   _scanningAnimationKey.currentState?.startScanningAnimation();
    // } else {
    //   _scanningAnimationKey.currentState?.stopScanningAnimation();
    // }
  }

  // Helper method to show the barcode dialog
  void _showBarcodeDialog({
    required BuildContext context,
    required String? title,
    required String? description,
    FoodRecord? foodRecord,
    String? barcode,
    required String? customFoodButtonText,
    bool fromCustomFood = false,
  }) {
    BarcodeDialog.show(
      context: context,
      title: title,
      description: description,
      onTapCancel: (dContext) {
        _visibleDialog = false;
        Navigator.pop(dContext);
        _startScanning();
      },
      onViewExistingItem: (dContext) async {
        Navigator.pop(dContext);
        await EditFoodPage.navigate(
          context: context,
          params: EditFoodPageParams(
            foodRecord: foodRecord,
            redirectToDiaryOnLog: true,
            visibleLogUponCreate: false,
          ),
        );
        _startScanning();
      },
      customFoodButtonText: customFoodButtonText,
      onCreateCustomFood: (dContext) {
        if (fromCustomFood) {
          foodRecord?.barcode = null;
        } else {
          Navigator.pop(dContext);
          Navigator.pop(context, barcode);
          return;
        }
        Navigator.pop(dContext);
        Navigator.pop(context);
        Navigator.pop(context);
        FoodCreatorPage.navigate(
          context: context,
          loggedFoodRecord: foodRecord,
        );
      },
    );
  }
}
