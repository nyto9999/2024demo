import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/methods/auth/auth_platform.dart';

part 'sms_sign_in_state.dart';

class SmsSignInCubit extends Cubit<SmsSignInState> {
  final AuthPlatform authMethods;
  SmsSignInCubit(this.authMethods) : super(SmsSignInInitial());

  dynamic result;

  Future<void> sendSmsSignInCode({
    required GlobalKey<FormState> formKey,
    required String phoneNo,
  }) async {
    if (!formKey.currentState!.validate()) {
      return emit(SmsSignInInitial());
    }

    try {

      // function
      result = await authMethods.sendSmsCode(phoneNo: phoneNo);

      emit(SmsSignInCodeSent(result));
    } catch (e) {
      emit(SmsSignInFailure(e.toString()));
    }
  }
}
