part of 'sign_up_bloc.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

/// [SignUpValidEmailErrorState] use this state to show the error state to the user for the email address.
class SignUpValidEmailErrorState extends SignUpState {}

/// [SignUpValidPasswordErrorState] use this state to show the error state to the user for the password.
class SignUpValidPasswordErrorState extends SignUpState {}