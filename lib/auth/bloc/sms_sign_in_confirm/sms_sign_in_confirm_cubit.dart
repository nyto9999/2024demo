import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:house/auth/auth_repo.dart';
import 'package:house/main.dart';
import 'package:meta/meta.dart';

part 'sms_sign_in_confirm_state.dart';

class SmsSignInConfirmCubit extends Cubit<SmsSignInConfirmState> {
  final AuthRepo authRepo;
  SmsSignInConfirmCubit(this.authRepo) : super(SmsSignInConfirmInitial());

  Future<void> confirmSmsSignInCode({
    required String smsCode,
    required dynamic result,
  }) async {
    if (smsCode.length != 6) return;

    emit(SmsSignInConfirmLoading());

    try {

      // function
      await authRepo.authMethods.confirmSmsCode(
          smsCode: smsCode,
          confirmationResult: result is ConfirmationResult ? result : null,
          verificationId: result is String ? result : null);

      if (auth.currentUser != null) {
        emit(SmsSignInConfirmSuccess());
      } else {
        emit(SmsSignInConfirmFailure('請稍後再嘗試'));
      }
    } catch (e) {
      emit(SmsSignInConfirmFailure(e.toString()));
    }
  }
}
