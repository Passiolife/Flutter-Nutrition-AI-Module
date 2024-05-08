part of 'my_profile_bloc.dart';

sealed class MyProfileEvent extends Equatable {
  const MyProfileEvent();
}

final class GetUserProfileEvent extends MyProfileEvent {
  const GetUserProfileEvent();

  @override
  List<Object?> get props => [];
}

final class DoNameUpdateEvent extends MyProfileEvent {
  const DoNameUpdateEvent(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class DoAgeUpdateEvent extends MyProfileEvent {
  const DoAgeUpdateEvent(this.age);

  final int? age;

  @override
  List<Object?> get props => [age];
}

final class DoGenderUpdateEvent extends MyProfileEvent {
  const DoGenderUpdateEvent(this.genderSelection);

  final GenderSelection genderSelection;

  @override
  List<Object?> get props => [genderSelection];
}

final class DoHeightUpdateEvent extends MyProfileEvent {
  const DoHeightUpdateEvent({required this.unit, required this.subunit});

  final int unit;
  final int subunit;

  @override
  List<Object?> get props => [unit, subunit];
}

final class DoWeightUpdateEvent extends MyProfileEvent {
  const DoWeightUpdateEvent(this.weight);

  final double? weight;

  @override
  List<Object?> get props => [weight];
}

final class DoTargetWeightUpdateEvent extends MyProfileEvent {
  const DoTargetWeightUpdateEvent(this.weight);

  final double? weight;

  @override
  List<Object?> get props => [weight];
}

final class DoActivityLevelUpdateEvent extends MyProfileEvent {
  const DoActivityLevelUpdateEvent(this.activityLevel);

  final ActivityLevel activityLevel;

  @override
  List<Object?> get props => [activityLevel];
}

final class DoCalorieDeficitUpdateEvent extends MyProfileEvent {
  const DoCalorieDeficitUpdateEvent(this.calorieDeficit);

  final CalorieDeficit calorieDeficit;

  @override
  List<Object?> get props => [calorieDeficit];
}

final class DoDietUpdateEvent extends MyProfileEvent {
  const DoDietUpdateEvent(this.mealPlan);

  final PassioMealPlan mealPlan;

  @override
  List<Object?> get props => [mealPlan];
}

final class DoTargetWaterUpdateEvent extends MyProfileEvent {
  const DoTargetWaterUpdateEvent(this.water);

  final double? water;

  @override
  List<Object?> get props => [water];
}

class DoNutritionTargetUpdateEvent extends MyProfileEvent {
  final UserProfileModel? userProfile;

  const DoNutritionTargetUpdateEvent({required this.userProfile});

  @override
  List<Object?> get props => [];
}

final class DoSaveProfileEvent extends MyProfileEvent {
  final UserProfileModel? userProfile;

  const DoSaveProfileEvent({required this.userProfile});

  @override
  List<Object?> get props => [];
}
