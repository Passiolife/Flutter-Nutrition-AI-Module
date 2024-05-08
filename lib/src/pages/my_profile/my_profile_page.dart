import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/user_profile/user_profile_model.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/keyboard_extension.dart';
import '../../common/util/snackbar_extension.dart';
import '../../common/widgets/app_button.dart';
import 'bloc/my_profile_bloc.dart';
import 'widgets/widgets.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  static Future navigate({required BuildContext context}) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyProfilePage()),
    );
  }

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    implements PersonalInformationListener, NutritionGoalsListener {
  UserProfileModel? _profileModel;

  final _bloc = MyProfileBloc();

  List<PassioMealPlan>? _mealPlans;

  @override
  void initState() {
    _bloc.add(const GetUserProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileBloc, MyProfileState>(
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
              CustomAppBarWidget(title: context.localization?.myProfile, isMenuVisible: false,),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: context.keyboardHeight),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        16.verticalSpace,
                        PersonalInformationWidget(
                          key: ValueKey(
                              '${_profileModel?.gender.name}-${_profileModel?.getHeight()}}'),
                          name: _profileModel?.name,
                          age: _profileModel?.getAge(),
                          gender: _profileModel?.gender,
                          heightUnit: _profileModel?.heightUnit ?? MeasurementSystem.imperial,
                          height: _profileModel?.heightInMeasurementSystem,
                          heightDescription: _profileModel?.getHeight() != null
                              ? _profileModel?.heightDescription
                              : '',
                          weight: _profileModel?.getWeight(),
                          weightUnit: _profileModel?.weightUnit ?? MeasurementSystem.imperial,
                          listener: this,
                        ),
                        16.verticalSpace,
                        NutritionGoalsWidget(
                          key: ValueKey(
                              '${_profileModel?.weightUnit}-${_profileModel?.getActivityLevel()}-${_profileModel?.getCalorieDeficit()}'),
                          targetWeight: _profileModel?.getTargetWeight(),
                          weightUnit: _profileModel?.weightUnit ?? MeasurementSystem.imperial,
                          activityLevel: _profileModel?.getActivityLevel(),
                          calorieDeficit: _profileModel?.getCalorieDeficit(),
                          targetWater: _profileModel?.getTargetWater(),
                          mealPlans: _mealPlans,
                          selectedMealPlan: _profileModel?.getPassioMealPlan(),
                          listener: this,
                        ),
                        16.verticalSpace,
                        (_profileModel?.recommendedCalories ?? 0) > 0
                            ? DailyNutritionWidgetWidget(
                                calories: _profileModel?.caloriesTarget ?? 0,
                                carbs: _profileModel?.carbsPercentage ?? 0,
                                carbsGrams: _profileModel?.carbsGram ?? 0,
                                proteins: _profileModel?.proteinPercentage ?? 0,
                                proteinGrams: _profileModel?.proteinGram ?? 0,
                                fat: _profileModel?.fatPercentage ?? 0,
                                fatGrams: _profileModel?.fatGram ?? 0,
                                profileModel: _profileModel,
                                onSave: (profileModel) {
                                  _profileModel = profileModel;
                                  _bloc.add(DoNutritionTargetUpdateEvent(
                                      userProfile: profileModel));
                                },
                              )
                            : const SizedBox.shrink(),
                        16.verticalSpace,
                        (_profileModel?.recommendedCalories ?? 0) > 0
                            ? CalculatedBMIWidget(
                                value: _profileModel?.bmi,
                              )
                            : const SizedBox.shrink(),
                        40.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AppButton(
                  buttonText: context.localization?.saveChanges,
                  appButtonModel: AppButtonStyles.primary,
                  onTap: () {
                    _bloc.add(DoSaveProfileEvent(userProfile: _profileModel));
                  },
                ),
              ),
              40.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  @override
  void onNameChanged(String name) {
    _bloc.add(DoNameUpdateEvent(name));
  }

  @override
  void onAgeChanged(int? age) {
    _bloc.add(DoAgeUpdateEvent(age));
  }

  @override
  void onGenderChanged(GenderSelection gender) {
    _bloc.add(DoGenderUpdateEvent(gender));
  }

  @override
  void onHeightChanged(int value1, int value2) {
    _bloc.add(DoHeightUpdateEvent(unit: value1, subunit: value2));
  }

  @override
  void onWeightChanged(double? weight) {
    _bloc.add(DoWeightUpdateEvent(weight));
  }

  @override
  void onTargetWeightChanged(double? targetWeight) {
    _bloc.add(DoTargetWeightUpdateEvent(targetWeight));
  }

  @override
  void onActivityLevelChanged(ActivityLevel activityLevel) {
    _bloc.add(DoActivityLevelUpdateEvent(activityLevel));
  }

  @override
  void onCalorieDeficitChanged(CalorieDeficit calorieDeficit) {
    _bloc.add(DoCalorieDeficitUpdateEvent(calorieDeficit));
  }

  @override
  void onDietChanged(PassioMealPlan mealPlan) {
    _bloc.add(DoDietUpdateEvent(mealPlan));
  }

  @override
  void onTargetWaterChanged(double? targetWater) {
    _bloc.add(DoTargetWaterUpdateEvent(targetWater));
  }

  void _handleStateChanges({
    required BuildContext context,
    required MyProfileState state,
  }) {
    if (state is GetUserProfileSuccessState) {
      _profileModel = state.profileModel;
      _mealPlans = state.mealPlans;
    } else if (state is SaveProfileSuccessState) {
      context.hideKeyboard();
      context.showSnackbar(text: context.localization?.profileSaved);
    }
  }
}
