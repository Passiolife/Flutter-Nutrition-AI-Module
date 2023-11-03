part of 'sign_in_bloc.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInErrorState extends SignInState {
  final String errorMessage;

  SignInErrorState(this.errorMessage);
}

/// [SignInValidEmailErrorState] use this state to show the error state to the user for the email address.
class SignInValidEmailErrorState extends SignInState {}

/// [SignInValidPasswordErrorState] use this state to show the error state to the user for the password.
class SignInValidPasswordErrorState extends SignInState {}

/// states for DoSignInEvent
class SignInLoadingState extends SignInState {
}

/// states for DoForgotPasswordEvent
class ForgotPasswordLoadingState extends SignInState {
}

