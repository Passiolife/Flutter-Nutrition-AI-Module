import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/connectors/passio_connector.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/util/user_session.dart';
import '../../../nutrition_ai_module_sdk.dart';

part 'my_profile_event.dart';
part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  UserProfileModel? _profileModel;

  MyProfileBloc() : super(const MyProfileInitial()) {
    on<GetUserProfileEvent>(_handleGetUserProfileEvent);
    on<DoNameUpdateEvent>(_handleDoNameUpdateEvent);
    on<DoAgeUpdateEvent>(_handleDoAgeUpdateEvent);
    on<DoGenderUpdateEvent>(_handleDoGenderUpdateEvent);
    on<DoHeightUpdateEvent>(_handleDoHeightUpdateEvent);
    on<DoWeightUpdateEvent>(_handleDoWeightUpdateEvent);
    on<DoTargetWeightUpdateEvent>(_handleDoTargetWeightUpdateEvent);
    on<DoActivityLevelUpdateEvent>(_handleDoActivityLevelUpdateEvent);
    on<DoCalorieDeficitUpdateEvent>(_handleDoCalorieDeficitUpdateEvent);
    on<DoDietUpdateEvent>(_handleDoDietUpdateEvent);
    on<DoTargetWaterUpdateEvent>(_handleDoTargetWaterUpdateEvent);
    on<DoNutritionTargetUpdateEvent>(_handleDoNutritionTargetUpdateEvent);
    on<DoSaveProfileEvent>(_handleDoSaveProfileEvent);
  }

  Future<void> _handleGetUserProfileEvent(
      GetUserProfileEvent event, Emitter<MyProfileState> emit) async {
    _profileModel =
        UserProfileModel.fromJson(UserSession.instance.userProfile!.toJson());
    final mealPlans = await NutritionAI.instance.fetchMealPlans();
    emit(GetUserProfileSuccessState(_profileModel, mealPlans));
  }

  FutureOr<void> _handleDoNameUpdateEvent(
      DoNameUpdateEvent event, Emitter<MyProfileState> emit) {
    _profileModel?.name = event.name;
    emit(NameUpdateSuccessState(name: _profileModel?.name));
  }

  Future<void> _handleDoAgeUpdateEvent(
      DoAgeUpdateEvent event, Emitter<MyProfileState> emit) async {
    _profileModel?.setAge(event.age);
    emit(AgeUpdateSuccessState(age: _profileModel?.getAge()));
  }

  Future<void> _handleDoGenderUpdateEvent(
      DoGenderUpdateEvent event, Emitter<MyProfileState> emit) async {
    _profileModel?.gender = event.genderSelection;
    emit(GenderUpdateSuccessState(gender: _profileModel?.gender));
  }

  Future<void> _handleDoHeightUpdateEvent(
      DoHeightUpdateEvent event, Emitter<MyProfileState> emit) async {
    _profileModel?.setHeight(event.unit, event.subunit);
    emit(HeightUpdateSuccessState(height: _profileModel?.getHeight()));
  }

  Future<void> _handleDoWeightUpdateEvent(
      DoWeightUpdateEvent event, Emitter<MyProfileState> emit) async {
    _profileModel?.setWeight(event.weight);
    emit(WeightUpdateSuccessState(weight: _profileModel?.getWeight()));
  }

  FutureOr<void> _handleDoTargetWeightUpdateEvent(
      DoTargetWeightUpdateEvent event, Emitter<MyProfileState> emit) {
    _profileModel?.setTargetWeight(event.weight ?? 0);
  }

  Future<void> _handleDoActivityLevelUpdateEvent(
      DoActivityLevelUpdateEvent event, Emitter<MyProfileState> emit) async {
    _profileModel?.setActivityLevel(event.activityLevel);
    emit(ActivityLevelSuccessState(
        activityLevel: _profileModel?.getActivityLevel()));
  }

  Future<void> _handleDoCalorieDeficitUpdateEvent(
      DoCalorieDeficitUpdateEvent event, Emitter<MyProfileState> emit) async {
    _profileModel?.setCalorieDeficit(event.calorieDeficit);
    emit(CalorieDeficitSuccessState(
        calorieDeficit: _profileModel?.getCalorieDeficit()));
  }

  Future<void> _handleDoDietUpdateEvent(
      DoDietUpdateEvent event, Emitter<MyProfileState> emit) async {
    _profileModel?.setPassioMealPlan(event.mealPlan);
    emit(DietSuccessState(mealPlan: _profileModel?.getPassioMealPlan()));
  }

  FutureOr<void> _handleDoTargetWaterUpdateEvent(
      DoTargetWaterUpdateEvent event, Emitter<MyProfileState> emit) {
    _profileModel?.setTargetWater(event.water ?? 0);
  }

  FutureOr<void> _handleDoNutritionTargetUpdateEvent(
      DoNutritionTargetUpdateEvent event, Emitter<MyProfileState> emit) {
    _profileModel = event.userProfile;
    emit(NutritionTargetUpdateState(
        createdAt: DateTime.now().millisecondsSinceEpoch));
  }

  Future<void> _handleDoSaveProfileEvent(
      DoSaveProfileEvent event, Emitter<MyProfileState> emit) async {
    if (event.userProfile != null) {
      UserSession.instance.userProfile = event.userProfile;
      // Here adding the default user profile data into firebase.
      await _connector.updateUserProfile(
          userProfile: event.userProfile!, isNew: false);
      emit(SaveProfileSuccessState(
          createdAt: DateTime.now().millisecondsSinceEpoch));
    }
  }
}
