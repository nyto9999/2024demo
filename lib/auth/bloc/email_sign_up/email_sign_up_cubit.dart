import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/methods/auth/auth_platform.dart';

part 'email_sign_up_state.dart';

class EmailSignUpCubit extends Cubit<EmailSignUpState> {
  final AuthPlatform auth;

  EmailSignUpCubit(this.auth) : super(EmailSignUpInitial());

  Future<void> signUpWithEmailAndPassword({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) {
      return emit(InvalidSignUpForm());
    }

    emit(EmailSignUpLoading());

    try {

      // function
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.sendEmailVerification();

      emit(EmailSignUpSuccess());
    } catch (e) {
      emit(EmailSignUpFailure(e.toString()));
    }
  }
}
