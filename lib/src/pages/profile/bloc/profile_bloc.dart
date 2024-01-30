import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/util/user_session.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserSession userSession = UserSession.instance;

  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  ProfileBloc() : super(ProfileInitial()) {
    on<DoWeightUpdateEvent>(_handleDoWeightUpdateEvent);
    on<DoHeightUpdateEvent>(_handleDoHeightUpdateEvent);
    on<DoCaloriesUpdateEvent>(_handleDoCaloriesUpdateEvent);
    on<DoMacroUpdateEvent>(_handleDoMacroUpdateEvent);
    on<DoGenderUpdateEvent>(_handleDoUpdateGenderEvent);
    on<DoUnitsUpdateEvent>(_handleDoUpdateUnitsEvent);
    on<DoSaveProfileEvent>(_handleDoSaveProfileEvent);
  }

  FutureOr<void> _handleDoWeightUpdateEvent(
      DoWeightUpdateEvent event, Emitter<ProfileState> emit) async {
    userSession.userProfile?.setWeightInKg(event.data);
    emit(WeightUpdateSuccessState());
  }

  FutureOr<void> _handleDoHeightUpdateEvent(
      DoHeightUpdateEvent event, Emitter<ProfileState> emit) async {
    userSession.userProfile
        ?.setHeightInMetersFor(event.valueOne, event.valueTwo);
    emit(HeightUpdateSuccessState());
  }

  FutureOr<void> _handleDoCaloriesUpdateEvent(
      DoCaloriesUpdateEvent event, Emitter<ProfileState> emit) async {
    userSession.userProfile?.caloriesTarget = event.data.toInt();
    emit(CaloriesUpdateSuccessState());
  }

  FutureOr<void> _handleDoMacroUpdateEvent(
      DoMacroUpdateEvent event, Emitter<ProfileState> emit) async {
    userSession.userProfile?.carbsPercent = event.carbsPercent;
    userSession.userProfile?.proteinPercent = event.proteinPercent;
    userSession.userProfile?.fatPercent = event.fatPercent;
    emit(MacroUpdateSuccessState());
  }

  FutureOr<void> _handleDoUpdateGenderEvent(
      DoGenderUpdateEvent event, Emitter<ProfileState> emit) async {
    userSession.userProfile?.gender = GenderSelection.values
        .firstWhere((element) => element.name == event.data);
    emit(GenderUpdateSuccessState());
  }

  FutureOr<void> _handleDoUpdateUnitsEvent(
      DoUnitsUpdateEvent event, Emitter<ProfileState> emit) {
    userSession.userProfile?.units = UnitSelection.values
        .firstWhere((element) => element.name == event.data);
    emit(UnitsUpdateSuccessState());
  }

  FutureOr<void> _handleDoSaveProfileEvent(
      DoSaveProfileEvent event, Emitter<ProfileState> emit) async {
    if (event.userProfile != null) {
      // Here adding the default user profile data into firebase.
      _connector.updateUserProfile(
          userProfile: event.userProfile!, isNew: false);
    }
  }
}
