import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';

part 'email_sign_up_state.dart';

class EmailSignUpCubit extends Cubit<EmailSignUpState> {
  final AuthUsecases usecases;

  EmailSignUpCubit(this.usecases) : super(EmailSignUpInitial());

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
      final credential = await usecases.createUserWithEmailAndPassword(
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
