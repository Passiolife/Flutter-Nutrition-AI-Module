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
import '../../common/util/string_extensions.dart';
import '../../common/widgets/custom_button.dart';
import '../../common/widgets/food_details/dialogs/rename_food_dialogs.dart';
import '../../common/widgets/food_details/food_details_widget.dart';
import '../../common/widgets/food_details/widgets/meal_time_widget.dart';
import 'bloc/quick_food_scan_bloc.dart';
import 'widgets/food_result_searching_widget.dart';
import 'widgets/food_result_widget.dart';

class QuickFoodScanPage extends StatefulWidget {
  const QuickFoodScanPage({required this.selectedDateTime, super.key});

  final DateTime selectedDateTime;

  static Future navigate(BuildContext context, DateTime dateTime) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => QuickFoodScanPage(selectedDateTime: dateTime)));
  }

  @override
  State<QuickFoodScanPage> createState() => _QuickFoodScanPageState();
}

class _QuickFoodScanPageState extends State<QuickFoodScanPage> implements FoodRecognitionListener {
  /// [_displayedFood] is currently visible to user when found any result in recognition.
  String? _displayedFood;

  /// [_foodRecord] is food data which we get from SDK.
  FoodRecord? _foodRecord;

  /// [_bloc] is
  final _bloc = QuickFoodScanBloc();

  /// [_hasRecordAdded] is by default false. If any record adds into the DB then flag will be true.
  /// If flag is true then we will refresh the dashboard page to fetch the data from DB.
  bool _hasRecordAdded = false;

  late final AppLifecycleListener _listener;

  /// [_updatedFoodRecord] contains the food record but it is useful while opening the food details screen
  /// and if user cancel that changes from food details widget then we will not update the original object.
  /// Else while saving we will update the object inside the list.
  FoodRecord? _updatedFoodRecord;

  GlobalKey<FoodDetailsWidgetState> _foodDetailsKey = GlobalKey();

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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasRecordAdded);
        return false;
      },
      child: BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {
          if (state is QuickFoodLoadingState) {
            _foodRecord = null;
            _displayedFood = null;
          } else if (state is QuickFoodSuccessState) {
            _handleQuickFoodSuccessState(state: state);
          }

          /// States for [ShowFoodDetailsViewEvent]
          else if (state is ShowFoodDetailsViewState) {
            _handleShowFoodDetailsViewState(state: state);
          }

          ///
          else if (state is FavoriteSuccessState) {
            context.showSnackbar(text: context.localization?.favoriteSuccessMessage);
          } else if (state is FavoriteFailureState) {
            context.showSnackbar(text: state.message);
          }

          ///
          else if (state is FoodInsertSuccessState) {
            context.showSnackbar(text: context.localization?.logSuccessMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.passioBackgroundWhite,
            resizeToAvoidBottomInset: false,
            body: Stack(
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
                      Navigator.maybePop(context, _hasRecordAdded);
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

                if (state is ShowFoodDetailsViewState && state.isVisible)
                  Align(
                    alignment: Alignment.center,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1.0),
                      duration: const Duration(milliseconds: Dimens.duration500),
                      builder: (BuildContext context, double value, Widget? child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: value,
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: Dimens.w8, right: Dimens.w8, top: context.topPadding),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.r16),
                            color: Colors.grey.shade200.withOpacity(Dimens.opacity50),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Dimens.h12.verticalSpace,
                              FoodDetailsWidget(
                                foodRecord: _updatedFoodRecord,
                                key: _foodDetailsKey,
                              ),
                              Dimens.h4.verticalSpace,
                              MealTimeWidget(
                                selectedMealLabel: _updatedFoodRecord?.mealLabel,
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
                                        _bloc.add(ShowFoodDetailsViewEvent(isVisible: false));
                                      },
                                      text: context.localization?.cancel ?? '',
                                    ),
                                  ),
                                  Dimens.w8.horizontalSpace,
                                  Expanded(
                                    child: CustomElevatedButton(
                                      onTap: () {
                                        _showFavoriteDialog();
                                      },
                                      text: context.localization?.favorites ?? '',
                                    ),
                                  ),
                                  Dimens.w8.horizontalSpace,
                                  Expanded(
                                    child: CustomElevatedButton(
                                      onTap: () {
                                        _updatedFoodRecord = _foodDetailsKey.currentState?.updatedFoodRecord;

                                        _hasRecordAdded = true;
                                        _bloc.add(DoLogEvent(data: _updatedFoodRecord));
                                        _bloc.add(ShowFoodDetailsViewEvent(isVisible: false));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text(context.localization?.logSuccessMessage ?? '')));
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
                  Positioned(
                    bottom: Dimens.h40,
                    left: Dimens.w8,
                    right: Dimens.w8,
                    child: _foodRecord != null
                        ? FoodResultWidget(
                            key: ValueKey(_foodRecord?.passioID ?? ''),
                            title: _foodRecord?.name,
                            subTitle: _foodRecord?.ingredients?.firstOrNull?.name ?? '',
                            passioID: _foodRecord?.passioID ?? '',
                            entityType: _foodRecord?.entityType ?? PassioIDEntityType.item,
                            onTapResult: () {
                              _bloc.add(ShowFoodDetailsViewEvent(isVisible: true));
                            },
                          )
                        : const FoodResultSearchingWidget(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void recognitionResults(FoodCandidates foodCandidates) {
    _bloc.add(RecognitionResultEvent(foodCandidates: foodCandidates, displayedResult: _displayedFood, dateTime: widget.selectedDateTime));
  }

  void _initialize() {
    // Initialize the AppLifecycleListener class and pass callbacks
    _listener = AppLifecycleListener(onStateChange: _onStateChanged);

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
      onUpdateStatus: (Permission? permission, bool isOpenSettingDialogVisible) async {
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
    var detectionConfig = FoodDetectionConfiguration(detectBarcodes: true, detectPackagedFood: true);
    NutritionAI.instance.startFoodDetection(detectionConfig, this);
  }

  Future<void> _stopFoodDetection() async {
    await NutritionAI.instance.stopFoodDetection();
  }

  void _handleQuickFoodSuccessState({required QuickFoodSuccessState state}) {
    _displayedFood = state.data;
    _foodRecord = state.foodRecord;
  }

  void _handleShowFoodDetailsViewState({required ShowFoodDetailsViewState state}) {
    _foodDetailsKey = GlobalKey();
    if (state.isVisible) {
      _updatedFoodRecord = FoodRecord.fromJson(_foodRecord?.toJson());
      _stopFoodDetection();
    } else {
      if (_updatedFoodRecord != null) {
        _updatedFoodRecord = null;
      }
      _checkPermission();
    }
  }

  void _showFavoriteDialog() {
    RenameFoodDialogs.show(
      context: context,
      title: context.localization?.favoriteDialogTitle,
      text: '',
      placeHolder: '${context.localization?.my} ${_updatedFoodRecord?.name}'.toUpperCaseWord,
      onRenameFood: (value) {
        _updatedFoodRecord?.name = value;

        _bloc.add(DoFavouriteEvent(data: _updatedFoodRecord, dateTime: DateTime.now()));
      },
    );
  }
}
