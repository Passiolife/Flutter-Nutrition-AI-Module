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
          _showBarcodeInSystemDialog(foodRecord: state.foodRecord);
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
            Navigator.pop(context);
          },
          onPositiveButtonTap: () async {
            Navigator.pop(context, foodRecord);
          },
          onNeutralButtonTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showBarcodeInSystemDialog({FoodRecord? foodRecord}) async {
    ShowWidgetUtil.showCustomGeneralDialogNew(
      barrierDismissible: false,
      context: context,
      builder: (dContext) {
        return BarcodeInSystemWidget(
          onNegativeButtonTap: () {
            Navigator.pop(context);
          },
          onPositiveButtonTap: () async {
            Navigator.pop(context, foodRecord);
          },
          onNeutralButtonTap: () {
            Navigator.pop(context, foodRecord?.barcode);
          },
        );
      },
    );
  }
}
