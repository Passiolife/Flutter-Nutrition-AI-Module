import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/app_images.dart';
import '../../common/constant/dimens.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/permission_manager_utility.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/widgets/custom_button.dart';
import '../../common/widgets/food_details/food_details_widget.dart';
import '../../common/widgets/food_details/widgets/meal_time_widget.dart';
import 'bloc/multi_food_scan_bloc.dart';
import 'dialogs/new_recipe_dialog.dart';
import 'widgets/bottom_sheet_list_row.dart';
import 'widgets/result_bottom_sheet.dart';

class MultiFoodScanPage extends StatefulWidget {
  const MultiFoodScanPage({required this.selectedDateTime, super.key});

  final DateTime selectedDateTime;

  static Future navigate(BuildContext context, DateTime dateTime) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MultiFoodScanPage(selectedDateTime: dateTime)));
  }

  @override
  State<MultiFoodScanPage> createState() => _MultiFoodScanPageState();
}

class _MultiFoodScanPageState extends State<MultiFoodScanPage>
    implements FoodRecognitionListener {
  ///
  final _bloc = MultiFoodScanBloc();

  /// [detectedList] contains list of [FoodRecord] data.
  final List<FoodRecord?> _detectedList = [];

  /// [_removedList] contains list of [FoodRecord] data which are removed particularly.
  final List<FoodRecord?> _removedList = [];

  /// _listKey
  GlobalKey<AnimatedListState>? _listKey;

  /// [_hasRecordAdded] is by default false. If any record adds into the DB then flag will be true.
  bool _hasRecordAdded = false;

  late final AppLifecycleListener _listener;

  /// [_updatedFoodRecord] contains the food record but it is useful while opening the food details screen
  /// and if user cancel that changes from food details widget then we will not update the original object.
  /// Else while saving we will update the object inside the list.
  FoodRecord? _updatedFoodRecord;

  final _foodDetailsKey = GlobalKey<FoodDetailsWidgetState>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _stopFoodDetection();
    _bloc.close();
    _listener.dispose();
    super.dispose();
  }

  @override
  void recognitionResults(FoodCandidates foodCandidates, PlatformImage? image) {
    _bloc.add(RecognitionResultEvent(
        foodCandidates: foodCandidates,
        list: _detectedList,
        removedList: _removedList,
        dateTime: widget.selectedDateTime));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _hasRecordAdded);
      },
      child: Scaffold(
        backgroundColor: AppColors.passioBackgroundWhite,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<MultiFoodScanBloc, MultiFoodScanState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is QuickFoodSuccessState) {
              _handleQuickFoodSuccessState(state: state);
            }

            /// States for [ShowFoodDetailsViewEvent]
            else if (state is ShowFoodDetailsViewState) {
              _handleShowFoodDetailsViewState(state: state);
            }

            ///
            else if (state is FoodInsertSuccessState) {
              _handleFoodInsertSuccessState(state: state);
            } else if (state is FoodInsertFailureState) {
              _handleFoodInsertFailureState(state: state);
            }
            // state for DoNewRecipeEvent
            else if (state is NewRecipeSuccessState) {
              _handleNewRecipeAddedState(state: state);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                /// [PassioPreview] is to detect the food.
                const PassioPreview(),

                /// Here, we are showing the close button.
                /// When user tap on the icon it will redirect to the previous screen.
                Positioned(
                  top: context.topPadding + Dimens.h24,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context, _hasRecordAdded);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: Dimens.w8),
                      child: Image.asset(
                        AppImages.icCancelCircle,
                        width: Dimens.r22,
                        height: Dimens.r22,
                      ),
                    ),
                  ),
                ),

                /// Here, we are showing the bottom sheet.
                if (state is ShowFoodDetailsViewState && state.isVisible)
                  Align(
                    alignment: Alignment.center,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1.0),
                      duration:
                          const Duration(milliseconds: Dimens.duration500),
                      builder:
                          (BuildContext context, double value, Widget? child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: value,
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: Dimens.w8,
                            right: Dimens.w8,
                            top: context.topPadding),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.r16),
                            color: Colors.grey.shade200
                                .withOpacity(Dimens.opacity50),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Dimens.h12.verticalSpace,
                              FoodDetailsWidget(
                                foodRecord: _updatedFoodRecord,
                                key: _foodDetailsKey,
                                isMealTimeVisible: false,
                                isIngredientsVisible: false,
                              ),
                              Dimens.h4.verticalSpace,
                              MealTimeWidget(
                                selectedMealLabel:
                                    _updatedFoodRecord?.mealLabel,
                                onUpdateMealTime: (label) {
                                  _updatedFoodRecord?.mealLabel = label;
                                },
                              ),
                              Dimens.h12.verticalSpace,
                              Row(
                                children: [
                                  Dimens.w4.horizontalSpace,
                                  Expanded(
                                    child: CustomElevatedButton(
                                      onTap: () {
                                        _bloc.add(ShowFoodDetailsViewEvent(
                                            isVisible: false,
                                            index: state.index));
                                      },
                                      text: context.localization?.cancel ?? '',
                                    ),
                                  ),
                                  Dimens.w8.horizontalSpace,
                                  Expanded(
                                    child: CustomElevatedButton(
                                      onTap: () {
                                        _updatedFoodRecord = _foodDetailsKey
                                            .currentState?.updatedFoodRecord;
                                        _detectedList[state.index] =
                                            _updatedFoodRecord;
                                        _bloc.add(ShowFoodDetailsViewEvent(
                                            isVisible: false,
                                            index: state.index));
                                      },
                                      text: context.localization?.save ?? '',
                                    ),
                                  ),
                                  Dimens.w4.horizontalSpace,
                                ],
                              ),
                              Dimens.h24.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Positioned.fill(
                    child: ResultBottomSheet(
                      detectedList: _detectedList,
                      onAnimationListRender: (key) {
                        _listKey = key;
                      },
                      onTapItem: (index) {
                        _bloc.add(ShowFoodDetailsViewEvent(
                            isVisible: true, index: index));
                      },
                      onTapClearItem: (index, data) {
                        _detectedList.remove(data);
                        _removedList.add(data);
                        _listKey?.currentState?.removeItem(
                            index,
                            (context, animation) => BottomSheetListRow(
                                foodRecord: data, animation: animation));
                      },
                      onTapClear: () {
                        _bloc.add(DoClearAllEvent());
                        _removedList.clear();
                        _detectedList.clear();
                        _listKey?.currentState?.removeAllItems(
                            (context, animation) => const SizedBox.shrink());
                      },
                      onTapAddAll: () {
                        _stopFoodDetection();
                        _hasRecordAdded = true;
                        _bloc.add(DoAddAllEvent(
                            data: _detectedList.toList(),
                            dateTime: widget.selectedDateTime));
                      },
                      onTapNewRecipe: () {
                        _stopFoodDetection();
                        NewRecipeDialog.show(
                          context: context,
                          text: '',
                          onSave: (value) {
                            _hasRecordAdded = true;
                            _bloc.add(DoNewRecipeEvent(
                                data: List.of(_detectedList),
                                name: value,
                                dateTime: widget.selectedDateTime));
                            _detectedList.clear();
                            _listKey?.currentState?.removeAllItems(
                                (context, animation) =>
                                    const SizedBox.shrink());
                            _startFoodDetection();
                          },
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _initialize() {
    // Initialize the AppLifecycleListener class and pass callbacks
    _listener = AppLifecycleListener(onStateChange: _onStateChanged);

    /// Here adding post frame callback to wait until UI is ready.
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _checkPermission();
    });
  }

  Future _checkPermission() async {
    PermissionManagerUtility().request(
      context,
      Permission.camera,
      title: context.localization?.permission,
      message: context.localization?.cameraPermissionMessage,
      onTapCancelForSettings: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      onUpdateStatus:
          (Permission? permission, bool isOpenSettingDialogVisible) async {
        if ((await permission?.isGranted) ?? false) {
          if (isOpenSettingDialogVisible) {
            PermissionManagerUtility().closeSettingDialog();
          }
          _startFoodDetection();
        }
      },
    );
  }

  void _onStateChanged(AppLifecycleState value) {
    PermissionManagerUtility().didChangeAppLifecycleState(value);
  }

  void _startFoodDetection() {
    var detectionConfig = FoodDetectionConfiguration(
        detectBarcodes: true, detectPackagedFood: true);
    NutritionAI.instance.startFoodDetection(detectionConfig, this);
  }

  void _stopFoodDetection() {
    NutritionAI.instance.stopFoodDetection();
  }

  void _handleQuickFoodSuccessState({required QuickFoodSuccessState state}) {
    _listKey?.currentState
        ?.insertItem(0, duration: const Duration(milliseconds: 500));
    _detectedList.insert(0, state.foodRecord);
  }

  void _handleShowFoodDetailsViewState(
      {required ShowFoodDetailsViewState state}) {
    if (state.isVisible) {
      final data = _detectedList.elementAt(state.index)?.toJson();
      if (data != null) {
        _updatedFoodRecord = FoodRecord.fromJson(data);
      }
      _stopFoodDetection();
    } else {
      if (_updatedFoodRecord != null) {
        _updatedFoodRecord = null;
      }
      _checkPermission();
    }
  }

  void _handleFoodInsertSuccessState({required FoodInsertSuccessState state}) {
    context.showSnackbar(text: context.localization?.logSuccessMessage);
    _checkPermission();
    _removedList.clear();
    _detectedList.clear();
    _listKey?.currentState
        ?.removeAllItems((context, animation) => const SizedBox.shrink());
  }

  void _handleFoodInsertFailureState({required FoodInsertFailureState state}) {
    _checkPermission();
    _removedList.clear();
    _detectedList.clear();
    _listKey?.currentState
        ?.removeAllItems((context, animation) => const SizedBox.shrink());
  }

  void _handleNewRecipeAddedState({required NewRecipeSuccessState state}) {
    context.showSnackbar(text: context.localization?.recipeAddedMessage);
  }
}
