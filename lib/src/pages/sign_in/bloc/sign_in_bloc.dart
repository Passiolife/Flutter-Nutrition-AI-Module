import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/util/string_extensions.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<ValidateEmailAddressEvent>(_validateEmailAddressEvent);
    on<ValidatePasswordEvent>(_validatePasswordEvent);
    on<DoSignInEvent>(_doSignInEvent);
    on<DoForgotPasswordEvent>(_doForgotPassword);
  }

  Future<void> _doSignInEvent(
      DoSignInEvent event, Emitter<SignInState> emit) async {
    if (!event.email.isValidEmail) {
      emit(SignInValidEmailErrorState());
    } else if (event.password.isEmpty || event.password.length < 6) {
      emit(SignInValidPasswordErrorState());
    } else {}
  }

  Future _validateEmailAddressEvent(
      ValidateEmailAddressEvent event, Emitter<SignInState> emit) async {
    if (!event.email.isValidEmail) {
      emit(SignInValidEmailErrorState());
    }
  }

  Future _validatePasswordEvent(
      ValidatePasswordEvent event, Emitter<SignInState> emit) async {
    if (event.password.isEmpty) {
      emit(SignInValidPasswordErrorState());
    }
  }

  Future _doForgotPassword(
      DoForgotPasswordEvent event, Emitter<SignInState> emit) async {
    /// Here, we are checking email address is valid or not.
    if (!event.email.isValidEmail) {
      /// If, email address is not valid then show validation message.
      emit(SignInValidEmailErrorState());
    } else {
      /// If, email address is not valid then show validation message.
      emit(SignInValidEmailErrorState());
    }
  }
}
