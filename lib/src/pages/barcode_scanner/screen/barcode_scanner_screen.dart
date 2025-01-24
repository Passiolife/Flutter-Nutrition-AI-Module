part of '../barcode_scanner_page.dart';

class _BarcodeScannerScreen extends StatefulWidget {
  const _BarcodeScannerScreen();

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen>
    with PermissionManagerLifeCycleMixin
    implements PermissionCallback {
  // Permission Manager
  late final PermissionManagerUtility _permissionManagerUtility =
      PermissionManagerUtilityImpl(callback: this);

  @override
  void onPermissionDenied(Permission permission) {}

  @override
  void onPermissionGranted(Permission permission) {
    _startScanning();
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkPermission();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BarcodeScannerBloc, BarcodeScannerState>(
      listener: _handleStateChanges,
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(title: context.localization.barcodeScanner),
            Expanded(child: const CameraSection()),
            // Expanded(
            //   child: Stack(
            //     fit: StackFit.expand,
            //     children: [
            //       _showPassioPreview
            //           ? const PassioPreview()
            //           : Container(color: AppColors.black),
            //       // TODO: Handle animation
            //       /*AnimatedOpacity(
            //             opacity: _visibleDialog ? 0 : 1,
            //             duration: const Duration(milliseconds: 250),
            //             child:
            //                 ScanningAnimationWidget(key: _scanningAnimationKey),
            //           ),*/
            //       Positioned(
            //         top: 110.h + 380.h,
            //         left: 0,
            //         right: 0,
            //         child: AnimatedOpacity(
            //           opacity: _visibleDialog ? 0 : 1,
            //           duration: const Duration(milliseconds: 250),
            //           child: const TutorialWidget(),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _checkPermission() {
    _permissionManagerUtility.requestPermissionWithSettingsDialog(
      context: context,
      permission: Permission.camera,
      title: context.localization.permission,
      description: context.localization.cameraPermissionMessage,
      onTapCancelForSettings: (permission) {
        Navigator.pop(context);
      },
    );
  }

  void _startScanning() {
    context.read<BarcodeScannerBloc>().add(const StartScanningEvent());
  }

  void _handleStateChanges(BuildContext context, BarcodeScannerState state) {
    if (state is ListenerState) {
      switch (state) {
        case CustomFoodRecordFoundListenerState():
          _showCustomFoodAlreadyExistsDialog(foodRecord: state.foodRecord);
          break;
        case SystemFoodRecordFoundListenerState():
          _showBarcodeInSystemDialog(
            barcode: state.barcode,
            foodRecord: state.foodRecord,
          );
          break;
        case UnknownBarcodeFoundListenerState():
          Navigator.pop(context, state.barcode);
          break;
      }
    }
  }

  void _showCustomFoodAlreadyExistsDialog({FoodRecord? foodRecord}) async {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      barrierDismissible: false,
      context: context,
      builder: (dContext) {
        return CustomFoodAlreadyExistsWidget(
          onNegativeButtonTap: () {
            Navigator.pop(dContext);
            Navigator.pop(context);
          },
          onPositiveButtonTap: () async {
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
          onNeutralButtonTap: () {
            Navigator.pop(dContext);
            foodRecord?.barcode = null;
            Navigator.pop(context, foodRecord);
            // _popAndReturnData(foodRecord: foodRecord);
          },
        );
      },
    );
  }

  void _showBarcodeInSystemDialog(
      {String? barcode, FoodRecord? foodRecord}) async {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      barrierDismissible: false,
      context: context,
      builder: (dContext) {
        return BarcodeInSystemWidget(
          onNegativeButtonTap: () {
            Navigator.pop(dContext);
            Navigator.pop(context);
          },
          onPositiveButtonTap: () async {
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
          onNeutralButtonTap: () {
            Navigator.pop(dContext);
            Navigator.pop(context, barcode);
          },
        );
      },
    );
  }
}
