part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

final class GetUserProfileSuccessState extends SettingsState {
  const GetUserProfileSuccessState(this.profileModel);

  final UserProfileModel? profileModel;

  @override
  List<Object?> get props => [profileModel];
}

final class RemindersSuccessState extends SettingsState {
  const RemindersSuccessState(
      {required this.breakfastEnabled,
      required this.lunchEnabled,
      required this.dinnerEnabled});

  final bool breakfastEnabled;
  final bool lunchEnabled;
  final bool dinnerEnabled;

  @override
  List<Object?> get props => [breakfastEnabled, lunchEnabled, dinnerEnabled];
}
