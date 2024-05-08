part of 'my_profile_bloc.dart';

sealed class MyProfileState extends Equatable {
  const MyProfileState();
}

final class MyProfileInitial extends MyProfileState {
  const MyProfileInitial();

  @override
  List<Object?> get props => [];
}

final class GetUserProfileSuccessState extends MyProfileState {
  const GetUserProfileSuccessState(this.profileModel, this.mealPlans);

  final UserProfileModel? profileModel;
  final List<PassioMealPlan> mealPlans;

  @override
  List<Object?> get props => [profileModel, mealPlans];
}

final class NameUpdateSuccessState extends MyProfileState {
  const NameUpdateSuccessState({required this.name});

  final String? name;

  @override
  List<Object?> get props => [name];
}

final class AgeUpdateSuccessState extends MyProfileState {
  const AgeUpdateSuccessState({required this.age});

  final int? age;

  @override
  List<Object?> get props => [age];
}

final class GenderUpdateSuccessState extends MyProfileState {
  const GenderUpdateSuccessState({required this.gender});

  final GenderSelection? gender;

  @override
  List<Object?> get props => [gender];
}

final class HeightUpdateSuccessState extends MyProfileState {
  const HeightUpdateSuccessState({this.height});

  final double? height;

  @override
  List<Object?> get props => [height];
}

final class WeightUpdateSuccessState extends MyProfileState {
  const WeightUpdateSuccessState({this.weight});

  final double? weight;

  @override
  List<Object?> get props => [weight];
}

final class ActivityLevelSuccessState extends MyProfileState {
  const ActivityLevelSuccessState({this.activityLevel});

  final ActivityLevel? activityLevel;

  @override
  List<Object?> get props => [activityLevel];
}

final class CalorieDeficitSuccessState extends MyProfileState {
  const CalorieDeficitSuccessState({this.calorieDeficit});

  final CalorieDeficit? calorieDeficit;

  @override
  List<Object?> get props => [calorieDeficit];
}

final class DietSuccessState extends MyProfileState {
  const DietSuccessState({this.mealPlan});

  final PassioMealPlan? mealPlan;

  @override
  List<Object?> get props => [mealPlan];
}

final class NutritionTargetUpdateState extends MyProfileState {
  const NutritionTargetUpdateState({required this.createdAt});

  final int createdAt;

  @override
  List<Object?> get props => [createdAt];
}

final class SaveProfileSuccessState extends MyProfileState {
  const SaveProfileSuccessState({required this.createdAt});

  final int createdAt;

  @override
  List<Object?> get props => [createdAt];
}
