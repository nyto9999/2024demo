import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';
part 'sms_sign_in_state.dart';

class SmsSignInCubit extends Cubit<SmsSignInState> {
  final AuthUsecases usecases;
  SmsSignInCubit(this.usecases) : super(SmsSignInInitial());

  dynamic result;

  Future<void> sendSmsSignInCode({
    required bool sent,
    required String smsCode,
    required GlobalKey<FormState> formKey,
    required String phoneNo,
  }) async {
    if (!formKey.currentState!.validate()) {
      return emit(SmsSignInInitial());
    }

    try {
      if (!sent) {
        result = await usecases.sendSmsCode(phoneNo: phoneNo);

        emit(SmsSignInCodeSent());
      } else {
        emit(SmsSignInConfirmationSent());

        await usecases.confirmSmsCode(
            smsCode: smsCode,
            confirmationResult: result is ConfirmationResult ? result : null,
            verificationId: result is String ? result : null);

        if (usecases.firebaseAuth.currentUser != null) {
          emit(SmsSignInSuccess());
        }
      }
    } catch (e) {
      emit(SmsSignInFailure(e.toString()));
    }
  }
}
