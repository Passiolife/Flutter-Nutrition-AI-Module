part of 'sign_in_bloc.dart';

abstract class SignInEvent {}

class ValidateEmailAddressEvent extends SignInEvent {
  final String email;

  ValidateEmailAddressEvent({required this.email});
}

class ValidatePasswordEvent extends SignInEvent {
  final String password;

  ValidatePasswordEvent({required this.password});
}

class DoSignInEvent extends SignInEvent {
  final String email;
  final String password;

  DoSignInEvent(this.email, this.password);
}

class DoForgotPasswordEvent extends SignInEvent {
  final String email;

  DoForgotPasswordEvent(this.email);
}
