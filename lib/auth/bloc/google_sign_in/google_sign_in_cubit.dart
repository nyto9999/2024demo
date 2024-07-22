import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/methods/auth/auth_platform.dart';

part 'google_sign_in_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  final AuthPlatform authMethods;
  GoogleSignInCubit(this.authMethods) : super(GoogleSignInInitial());

  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoading());
    try {

      // function
      authMethods.signInWithGoogle().then((crendential) {
        if (_verifyFailed(crendential)) {
          emit(GoogleSignInFailure('請稍後再試'));
        } else {

          
          emit(GoogleSignInSuccess());
        }
      });
    } catch (e) {
      emit(GoogleSignInFailure(e.toString()));
    }
  }

  bool _verifyFailed(UserCredential crendential) {
    return crendential.user == null || crendential.user?.emailVerified == false;
  }
}
