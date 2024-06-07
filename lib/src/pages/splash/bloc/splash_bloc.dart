import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/util/user_session.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  /// [_userSession] keeps the user information.
  final _userSession = UserSession.instance;

  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  SplashBloc() : super(SplashInitial()) {
    on<DoConfigureSdkEvent>(_handleDoConfigureSdk);
  }

  Future _handleDoConfigureSdk(
      DoConfigureSdkEvent event, Emitter<SplashState> emit) async {
    emit(ConfigureLoadingState(isLoading: true));

    try {
      /// Here, we are checking the platform version.
      final platformVersion = await NutritionAI.instance.getSDKVersion();
      if (platformVersion == null || platformVersion.isEmpty) {
        /// If unknown platform then fire failure state.
        emit(ConfigureFailureState(message: 'Unknown platform version'));
      }
    } on PlatformException {
      /// If any [PlatformException] then fire failure state.
      emit(ConfigureFailureState(message: 'Failed to get platform version.'));
    }

    String passioKey = NutritionAIModule.instance.configuration.key ?? '';
    var configuration = PassioConfiguration(passioKey);

    /// [configureSDK] method is use to initialize the SDK.
    final passioStatus = await NutritionAI.instance.configureSDK(configuration);

    /// Here, we are checking if sdk is ready for detection.
    if (passioStatus.mode == PassioMode.isReadyForDetection) {
      // Getting user profile from connector.
      final result = await _connector.fetchUserProfile();
      if (result != null) {
        // Updating user profile data from database.
        _userSession.userProfile = result;
      } else {
        // Then assigning default  [UserProfileModel] to the user session.
        _userSession.userProfile = UserProfileModel();
        if (_userSession.userProfile != null) {
          // Storing user profile data in database.
          await _connector.updateUserProfile(
              userProfile: _userSession.userProfile!, isNew: true);
        }
      }
      emit(ConfigureSuccessState());
    } else {
      emit(ConfigureFailureState(message: passioStatus.debugMessage ?? ''));
    }
  }
}
