import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/food_record/meal_label.dart';
import '../../common/models/user_profile/user_profile_model.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/permission_manager_utility.dart';
import '../../common/util/string_extensions.dart';
import '../../common/widgets/custom_app_bar_widget.dart';
import 'bloc/settings_bloc.dart';
import 'widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static Future navigate({required BuildContext context}) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _bloc = SettingsBloc();

  UserProfileModel? _profileModel;

  // Reminders
  bool _breakfastEnabled = false;
  bool _lunchEnabled = false;
  bool _dinnerEnabled = false;

  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  final PermissionManagerUtility _permissionManager =
      PermissionManagerUtility();

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              CustomAppBarWidget(
                title: context.localization?.settings,
                isMenuVisible: false,
              ),
              16.verticalSpace,
              UnitsForProfileWidget(
                initialHeightMeasurement: _profileModel?.heightUnit,
                onHeightMeasurementChanged: (value) {
                  _bloc.add(DoUpdateHeightUnitEvent(measurementSystem: value));
                },
                initialWeightMeasurement: _profileModel?.weightUnit,
                onWeightMeasurementChanged: (value) {
                  _bloc.add(DoUpdateWeightUnitEvent(measurementSystem: value));
                },
              ),
              16.verticalSpace,
              RemindersWidget(
                breakfastEnabled: _breakfastEnabled,
                lunchEnabled: _lunchEnabled,
                dinnerEnabled: _dinnerEnabled,
                onChangedBreakfast: (value) async {
                  _updateReminder(
                    value,
                    context.localization?.breakfast ?? '',
                    const TimeOfDay(hour: 5, minute: 0),
                    MealLabel.breakfast,
                  );
                },
                onChangedLunch: (value) {
                  _updateReminder(
                    value,
                    context.localization?.lunch ?? '',
                    const TimeOfDay(hour: 12, minute: 0),
                    MealLabel.lunch,
                  );
                },
                onChangedDinner: (value) {
                  _updateReminder(
                    value,
                    context.localization?.dinner ?? '',
                    const TimeOfDay(hour: 17, minute: 0),
                    MealLabel.dinner,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _initialize() {
    _bloc.add(const GetUserProfileEvent());
    _bloc.add(const GetRemindersEvent());

    // Create an AppLifecycleListener to listen for changes in the app lifecycle
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        // Call permission manager to handle app lifecycle state change
        _permissionManager.didChangeAppLifecycleState(state);
      },
    );
  }

  void _updateReminder(
      bool value, String mealString, TimeOfDay timeOfDay, MealLabel mealTime) {
    _checkPermission(
      () {
        _bloc.add(DoUpdateMealReminderEvent(
          enabled: value,
          title: context.localization?.mealReminder ?? '',
          description:
              context.localization?.mealReminderMessage?.format([mealString]) ??
                  '',
          reminderTime: timeOfDay,
          mealTime: mealTime,
        ));
      },
    );
  }

  void _handleStateChanges(
      {required BuildContext context, required SettingsState state}) {
    if (state is GetUserProfileSuccessState) {
      _profileModel = state.profileModel;
    } else if (state is RemindersSuccessState) {
      _breakfastEnabled = state.breakfastEnabled;
      _lunchEnabled = state.lunchEnabled;
      _dinnerEnabled = state.dinnerEnabled;
    }
  }

  void _checkPermission(VoidCallback? onAllowed) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await _permissionManager.request(
        context,
        Permission.notification,
        title: context.localization?.permission,
        message: context.localization?.notificationPermissionMessage,
        onUpdateStatus: (Permission? permission) async {
          if (((await permission?.isGranted) ?? false) ||
              (await permission?.isLimited ?? false)) {
            if (Platform.isAndroid) {
              if (context.mounted) {
                await _permissionManager.request(
                  context,
                  Permission.scheduleExactAlarm,
                  onUpdateStatus: (Permission? permission) async {
                    if (((await permission?.isGranted) ?? false) ||
                        (await permission?.isLimited ?? false)) {
                      onAllowed?.call();
                    }
                  },
                );
              }
            } else {
              onAllowed?.call();
            }
          }
        },
      );
    });
  }
}
