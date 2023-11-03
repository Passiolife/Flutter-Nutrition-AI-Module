part of 'sign_up_bloc.dart';

abstract class SignUpEvent {}

class ValidateEmailAddressEvent extends SignUpEvent {
  final String email;

  ValidateEmailAddressEvent({required this.email});
}

class ValidatePasswordEvent extends SignUpEvent {
  final String password;

  ValidatePasswordEvent({required this.password});
}

class DoSignUpEvent extends SignUpEvent {
  final String email;
  final String password;

  DoSignUpEvent(this.email, this.password);
}
