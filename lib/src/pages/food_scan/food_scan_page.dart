import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/settings/settings.dart';
import '../../common/router/routes.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/permission_manager_utility.dart';
import 'bloc/food_scan_bloc.dart';
import 'dialog/added_to_diary_dialog.dart';
import 'dialog/barcode_not_recognized_dialog.dart';
import 'dialog/intro_dialog.dart';
import 'dialog/scanned_nutrition_facts_dialog.dart';
import 'widgets/widgets.dart';

class FoodScanPage extends StatefulWidget {
  const FoodScanPage({required this.selectedDateTime, super.key});

  final DateTime selectedDateTime;

  @override
  State<FoodScanPage> createState() => _FoodScanPageState();
}

class _FoodScanPageState extends State<FoodScanPage>
    with TickerProviderStateMixin
    implements FoodScanListener {
  // Instance of PermissionManagerUtility to handle permissions
  final PermissionManagerUtility _permissionManager =
      PermissionManagerUtility();

  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  // Bloc instance responsible for managing the state of the FoodScan feature
  final FoodScanBloc _bloc = FoodScanBloc();

  final GlobalKey<ScanningAnimationWidgetState> _scanningAnimationKey =
      GlobalKey<ScanningAnimationWidgetState>();

  bool _showPassioPreview = false;

  final GlobalKey<ResultWidgetState> _resultKey = GlobalKey();

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color
      backgroundColor: AppColors.gray50,
      // Prevent the screen from resizing when the keyboard is shown
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<FoodScanBloc, FoodScanState>(
        bloc: _bloc,
        listener: (context, state) {
          _handleStateChanges(state, context);
        },
        buildWhen: (_, state) => state is! ScanningAnimationState,
        builder: (context, state) {
          return Column(
            children: [
              FoodScanAppBarWidget(
                onTapHelp: () {
                  _bloc.add(const IntroScreenEvent(shouldVisible: true));
                },
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _showPassioPreview
                        ? const PassioPreview()
                        : Container(color: AppColors.black),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: state is ScanResultVisibilityState
                          ? () => _resultKey.currentState?.setInitialHeight()
                          : null,
                      child:
                          ScanningAnimationWidget(key: _scanningAnimationKey),
                    ),
                    (state is ScanningState)
                        ? const ScanningWidget()
                        : const SizedBox.shrink(),
                    (state is ScanResultVisibilityState)
                        ? ResultWidget(
                            key: _resultKey,
                            iconId: state.iconId,
                            foodName: state.foodName,
                            alternatives: state.alternatives,
                            listener: this,
                            shouldDraggable: state.alternatives.isNotEmpty,
                            visibleDragIntro: Settings.instance.getDragIntroSeen(),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
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
        _permissionManager.didChangeAppLifecycleState(state);
      },
    );

    // Trigger the IntroScreenEvent in the bloc to initialize the intro screen
    _bloc.add(const IntroScreenEvent());
    // _bloc.add(const ScanResultVisibilityEvent(shouldVisible: true));
  }

  // Handle different state changes
  void _handleStateChanges(FoodScanState state, BuildContext context) {
    if (state is ShowNutritionFactsDialogState) {
      ScannedNutritionFactsDialog.show(context: context);
    } else if (state is BarcodeNotRecognizedState) {
      _handleBarcodeNotRecognizedState(state);
    } else if (state is IntroVisibilityState) {
      _handleIntroVisibilityState(state);
    } else if (state is ScanningState) {
      _handleScanningState(state);
    } else if (state is AddedToDiaryVisibilityState) {
      _handleAddedToDiaryVisibilityState(state);
    } else if (state is ScanningAnimationState) {
      _handleScanningAnimationState(state.shouldAnimate);
    }
  }

  // Handle intro screen visibility
  void _handleIntroVisibilityState(IntroVisibilityState state) {
    if (state.shouldVisible) {
      IntroDialog.show(
        context: context,
        onTapOk: (context) {
          Navigator.pop(context);
          _checkPermission();
          _bloc.add(const IntroScreenCompleteEvent());
        },
      );
    } else {
      // Check for permissions
      _checkPermission();
    }
  }

  // Check camera permission
  Future _checkPermission() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await PermissionManagerUtility().request(
        context,
        Permission.camera,
        title: context.localization?.permission,
        message: context.localization?.cameraPermissionMessage,
        onTapCancelForSettings: (contextPermission) {
          Navigator.pop(contextPermission);
          Navigator.pop(context);
        },
        onUpdateStatus:
            (Permission? permission, bool isOpenSettingDialogVisible) async {
          if ((await permission?.isGranted) ?? false) {
            if (isOpenSettingDialogVisible) {
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }
            _bloc.add(const StartScanningEvent());
          }
        },
      );
    });
  }

  // Handle scanning animation
  void _handleScanningState(ScanningState state) {
    if (!_showPassioPreview) {
      _showPassioPreview = true;
    }
    _handleScanningAnimationState(true);
  }

  // Handle scan result visibility
  void _handleScanningAnimationState(bool shouldStart) {
    if (shouldStart) {
      _scanningAnimationKey.currentState?.startScanningAnimation();
    } else {
      _scanningAnimationKey.currentState?.stopScanningAnimation();
    }
  }

  void _handleAddedToDiaryVisibilityState(AddedToDiaryVisibilityState state) {
    AddedToDiaryDialog.show(
      context: context,
      onTapViewDiary: (dialogContext) {
        Navigator.pop(dialogContext);
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.dashboardPage,
          (route) => false,
          arguments: {
            AppCommonConstants.page: dialogContext.localization?.diary
          },
        );
      },
      onTapContinue: (dialogContext) {
        Navigator.pop(dialogContext);
        _bloc.add(const StartScanningEvent());
      },
    );
  }

  void _handleBarcodeNotRecognizedState(BarcodeNotRecognizedState state) {
    _handleScanningAnimationState(!state.shouldVisible);
    BarcodeNotRecognizedDialog.show(
      context: context,
      onTapCancel: (context) {
        Navigator.pop(context);
        _bloc.add(const StartScanningEvent());
      },
      onTapScanNutrition: (context) {
        Navigator.pop(context);
        _bloc.add(const StartScanningEvent());
      },
    );
  }

  @override
  void onDragResult(bool isCollapsed) {
    _bloc.add(ScanResultDragEvent(isCollapsed: isCollapsed));
  }

  @override
  void onEdit() {
    // TODO: implement onEdit
  }

  @override
  void onLog() {
    // TODO: implement onLog
  }
}
