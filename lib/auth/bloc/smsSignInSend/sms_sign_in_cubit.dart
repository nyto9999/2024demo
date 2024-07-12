import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';
part 'sms_sign_in_state.dart';

class SmsSignInCubit extends Cubit<SmsSignInState> {
  final AuthUsecases usecases;
  SmsSignInCubit(this.usecases) : super(SmsSignInInitial());

  dynamic result;

  Future<void> sendSmsSignInCode({
    required GlobalKey<FormState> formKey,
    required String phoneNo,
  }) async {
    if (!formKey.currentState!.validate()) {
      return emit(SmsSignInInitial());
    }

    try {
      result = await usecases.sendSmsCode(phoneNo: phoneNo);

      emit(SmsSignInCodeSent(result));
    } catch (e) {
      emit(SmsSignInFailure(e.toString()));
    }
  }
}
