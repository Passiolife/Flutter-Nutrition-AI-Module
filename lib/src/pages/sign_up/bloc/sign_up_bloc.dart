import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/util/string_extensions.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<ValidateEmailAddressEvent>(_validateEmailAddressEvent);
    on<ValidatePasswordEvent>(_validatePasswordEvent);
    on<DoSignUpEvent>(_doSignUpEvent);
  }

  Future<void> _doSignUpEvent(DoSignUpEvent event, Emitter<SignUpState> emit) async {
    if (!event.email.isValidEmail) {
      emit(SignUpValidEmailErrorState());
    } else if (event.password.isEmpty || event.password.length < 6) {
      emit(SignUpValidPasswordErrorState());
    } else {}
  }

  Future _validateEmailAddressEvent(ValidateEmailAddressEvent event, Emitter<SignUpState> emit) async {
    if (!event.email.isValidEmail) {
      emit(SignUpValidEmailErrorState());
    }
  }

  Future _validatePasswordEvent(ValidatePasswordEvent event, Emitter<SignUpState> emit) async {
    if (event.password.isEmpty) {
      emit(SignUpValidPasswordErrorState());
    }
  }
}
