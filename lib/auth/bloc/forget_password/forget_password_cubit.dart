import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/methods/auth/auth_platform.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthPlatform auth;
  ForgetPasswordCubit(this.auth) : super(ForgetPasswordInitial());

  Future<void> forgetPassword({
    required GlobalKey<FormState> formKey,
    required String email,
  }) async {
    if (!formKey.currentState!.validate()) {
      return emit(InvalidForgetPasswordForm());
    }

    emit(ForgetPasswordLoading());

    try {

      // function
      await auth.forgetPassword(email);
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }
}
