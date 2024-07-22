import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/methods/auth/auth_platform.dart';

part 'email_sign_in_state.dart';

class EmailSignInCubit extends Cubit<EmailSignInState> {
  final AuthPlatform auth;
  EmailSignInCubit(this.auth) : super(EmailSignInInitial());

  Future<void> signInWithEmailAndPassword({
    required GlobalKey<FormState> formKey,
    required String email,
    required String password,
  }) async {
    if (!formKey.currentState!.validate()) {
      return emit(InvalidSignInForm());
    }

    emit(EmailSignInLoading());

    try {

      // function
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_emailVerify(credential)) {
        emit(EmailSignInSuccess());
      } else {
        await credential.user?.sendEmailVerification();
        emit(EmailNotVerified());
      }
    } catch (e) {
      emit(EmailSignInFailure(e.toString()));
    }
  }

  bool _emailVerify(UserCredential credential) {
    return credential.user?.emailVerified == true;
  }
}
