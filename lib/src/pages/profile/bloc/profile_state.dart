part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

// States for [DoWeightUpdateEvent]
class WeightUpdateSuccessState extends ProfileState {}

// States for [DoHeightUpdateEvent]
class HeightUpdateSuccessState extends ProfileState {}

// States for [DoCaloriesUpdateEvent]
class CaloriesUpdateSuccessState extends ProfileState {}

// States for [DoMacroUpdateEvent]
class MacroUpdateSuccessState extends ProfileState {}

// States for [DoGenderUpdateEvent]
class GenderUpdateSuccessState extends ProfileState {}

// States for [DoUnitsUpdateEvent]
class UnitsUpdateSuccessState extends ProfileState {}

// States for [DoSaveProfileEvent]
class ProfileSaveSuccessState extends ProfileState {}

class ProfileSaveFailedState extends ProfileState {}
