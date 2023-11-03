part of 'splash_bloc.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

/// States for [DoConfigureSdkEvent].
class ConfigureLoadingState extends SplashState {
  final bool isLoading;

  ConfigureLoadingState({required this.isLoading});
}

class ConfigureSuccessState extends SplashState {}

class ConfigureFailureState extends SplashState {
  final String message;

  ConfigureFailureState({required this.message});
}
