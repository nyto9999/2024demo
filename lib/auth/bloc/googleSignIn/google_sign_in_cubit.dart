import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';

part 'google_sign_in_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  final AuthUsecases usecases;
  GoogleSignInCubit(this.usecases) : super(GoogleSignInInitial());

  Future<void> signInWithGoogle( ) async {
    emit(GoogleSignInLoading());
    try {
      usecases.signInWithGoogle().then((crendential) {
        _verifyFailed(crendential)
            ? emit(GoogleSignInFailure('請稍後再試'))
            : emit(GoogleSignInSuccess());
      });
    } catch (e) {
      emit(GoogleSignInFailure(e.toString()));
    }
  }

  bool _verifyFailed(UserCredential crendential) {
    return crendential.user == null || crendential.user?.emailVerified == false;
  }
}
