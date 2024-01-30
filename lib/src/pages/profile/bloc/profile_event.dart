part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class DoWeightUpdateEvent extends ProfileEvent {
  double data;

  DoWeightUpdateEvent({required this.data});
}

class DoHeightUpdateEvent extends ProfileEvent {
  final int valueOne;
  final int valueTwo;

  DoHeightUpdateEvent({required this.valueOne, required this.valueTwo});
}

class DoCaloriesUpdateEvent extends ProfileEvent {
  final double data;

  DoCaloriesUpdateEvent({required this.data});
}

class DoMacroUpdateEvent extends ProfileEvent {
  final int carbsPercent;
  final int proteinPercent;
  final int fatPercent;

  DoMacroUpdateEvent({required this.carbsPercent, required this.proteinPercent, required this.fatPercent});
}

class DoGenderUpdateEvent extends ProfileEvent {
  final String? data;

  DoGenderUpdateEvent({required this.data});
}

class DoUnitsUpdateEvent extends ProfileEvent {
  final String? data;

  DoUnitsUpdateEvent({required this.data});
}

class DoSaveProfileEvent extends ProfileEvent {
  final UserProfileModel? userProfile;

  DoSaveProfileEvent({required this.userProfile});
}
