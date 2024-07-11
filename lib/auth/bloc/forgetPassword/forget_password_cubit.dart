import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthUsecases usecases;
  ForgetPasswordCubit(this.usecases) : super(ForgetPasswordInitial());

  Future<void> forgetPassword({
    required GlobalKey<FormState> formKey,
    required String email,
  }) async {
    if (!formKey.currentState!.validate()) {
      return emit(InvalidForgetPasswordForm());
    }

    emit(ForgetPasswordLoading());

    try {
      await usecases.forgetPassword(email);
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }
}
