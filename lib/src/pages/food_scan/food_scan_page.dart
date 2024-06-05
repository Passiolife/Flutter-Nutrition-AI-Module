import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/settings/settings.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/permission_manager_utility.dart';
import '../dashboard/dashboard_page.dart';
import '../edit_food/edit_food_page.dart';
import '../food_search/food_search_page.dart';
import 'bloc/food_scan_bloc.dart';
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

  // This flag controls the visibility of the Passio preview,
  // ensuring it's only shown after the screen has rendered to provide a smoother navigation experience.
  bool _showPassioPreview = false;

  final GlobalKey<BottomBackgroundWidgetState> _bottomBackgroundWidgetKey =
      GlobalKey();

  bool _sheetDraggable = false;

  PassioFoodItem? _foodItem;
  DetectedCandidate? _detectedCandidate;
  List<DetectedCandidate> _alternatives = [];

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
        buildWhen: (_, state) =>
            state is! ScanningAnimationState &&
            state is! ConversionSuccessState,
        builder: (context, state) {
          return Column(
            children: [
              CustomAppBarWidget(
                title: context.localization?.foodScanner,
                isMenuVisible: false,
                suffix: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _bloc.add(const IntroScreenEvent(shouldVisible: true));
                  },
                  child: SvgPicture.asset(
                    AppImages.icQuestionMarkCircle,
                    width: AppDimens.r24,
                    height: AppDimens.r24,
                  ),
                ),
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
                      onTap: state is ScanResultState
                          ? () => _bottomBackgroundWidgetKey.currentState
                              ?.setInitialHeight()
                          : null,
                      child:
                          ScanningAnimationWidget(key: _scanningAnimationKey),
                    ),
                    (state is ScanLoadingState || state is ScanResultState)
                        ? BottomBackgroundWidget(
                            key: _bottomBackgroundWidgetKey,
                            shouldDraggable: _sheetDraggable,
                            visibleDragIntro:
                                !Settings.instance.getDragIntroSeen(),
                            listener: this,
                            child: state is ScanResultState
                                ? ResultWidget(
                                    bottomBackgroundWidgetKey:
                                        _bottomBackgroundWidgetKey,
                                    iconId: _foodItem?.iconId ??
                                        _detectedCandidate?.passioID ??
                                        '',
                                    foodName: _foodItem?.name ??
                                        _detectedCandidate?.foodName ??
                                        '',
                                    alternatives: _alternatives,
                                    listener: this,
                                    shouldDraggable: _sheetDraggable,
                                    visibleDragIntro:
                                        !Settings.instance.getDragIntroSeen(),
                                  )
                                : const ScanningWidget(),
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
  }

  // Handle different state changes
  void _handleStateChanges(FoodScanState state, BuildContext context) {
    if (state is ShowNutritionFactsDialogState) {
      ScannedNutritionFactsDialog.show(context: context);
    } else if (state is BarcodeNotRecognizedState) {
      _handleBarcodeNotRecognizedState(state);
    } else if (state is PackagedFoodNotRecognizedState) {
      _handlePackagedFoodNotRecognizedState(state);
    } else if (state is IntroScreenVisibilityState) {
      _handleIntroVisibilityState(state);
    } else if (state is ScanningState) {
      _handleScanningState(state);
    } else if (state is AddedToDiaryVisibilityState) {
      _handleAddedToDiaryVisibilityState(state);
    } else if (state is ScanningAnimationState) {
      _handleScanningAnimationState(state.shouldAnimate);
    } else if (state is ScanResultState) {
      _foodItem = state.foodItem;
      _detectedCandidate = state.detectedCandidate;
      _alternatives = state.alternatives;
      _sheetDraggable = _alternatives.isNotEmpty;
      if (_alternatives.isNotEmpty) {
        _bottomBackgroundWidgetKey.currentState?.setMaxSizeWithInitialInPixels(
            AppDimens.h32 + (_alternatives.length * AppDimens.h56));
      }
    } else if (state is ConversionSuccessState) {
      _redirectToEdit(state.foodItem);
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
            _bloc.add(const IntroScreenCompleteEvent());
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
          _bloc.add(const StartScanningEvent());
        }
      },
    );
  }

  // Handle scanning animation
  void _handleScanningState(ScanningState state) {
    if (!_showPassioPreview) {
      _showPassioPreview = true;
    }
    _sheetDraggable = false;
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
        DashboardPage.navigate(
          context,
          page: 1,
          removeUntil: true,
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
        Future.delayed(const Duration(milliseconds: AppDimens.duration150), () {
          _bloc.add(const StartScanningEvent());
        });
      },
      onTapScanNutrition: (context) {
        Navigator.pop(context);
        _bloc.add(const StartScanningEvent());
      },
    );
  }

  void _handlePackagedFoodNotRecognizedState(
      PackagedFoodNotRecognizedState state) {
    _handleScanningAnimationState(!state.shouldVisible);
    PackagedFoodNotRecognizedDialog.show(
      context: context,
      onTapCancel: (context) {
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: AppDimens.duration150), () {
          _bloc.add(const StartScanningEvent());
        });
      },
      onTapScanNutrition: (context) {
        Navigator.pop(context);
        _bloc.add(const StartScanningEvent());
      },
    );
  }

  @override
  void onDragResult(bool isCollapsed) {
    if (isCollapsed) {
      Future.delayed(const Duration(milliseconds: AppDimens.duration150), () {
        _bloc.add(ScanResultDragEvent(isCollapsed: isCollapsed));
      });
    } else {
      _scanningAnimationKey.currentState?.stopScanningAnimation();
      _bloc.add(ScanResultDragEvent(isCollapsed: isCollapsed));
    }
  }

  @override
  Future<void> onEdit(int? index) async {
    DetectedCandidate? candidate;
    if (index != null) {
      candidate = _alternatives.elementAt(index);
    } else {
      candidate = _detectedCandidate;
    }
    EditFoodPage.navigate(
        context: context,
        foodItem: _foodItem,
        detectedCandidate: candidate,
        redirectToDiaryOnLog: true);
  }

  @override
  void onLog() {
    _bloc.add(DoFoodLogEvent(
        dateTime: DateTime.now(),
        foodItem: _foodItem,
        detectedCandidate: _detectedCandidate));
  }

  void _redirectToEdit(PassioFoodItem? foodItem) {
    EditFoodPage.navigate(
      context: context,
      foodItem: foodItem,
      visibleSwitch: true,
    );
  }

  @override
  void onTapSearch() {
    FoodSearchPage.navigate(context, needsReturn: false);
  }
}
