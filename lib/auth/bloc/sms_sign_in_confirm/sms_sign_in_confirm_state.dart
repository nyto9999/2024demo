part of 'sms_sign_in_confirm_cubit.dart';

@immutable
sealed class SmsSignInConfirmState {}

final class SmsSignInConfirmInitial extends SmsSignInConfirmState {}

final class SmsSignInConfirmSuccess extends SmsSignInConfirmState {}

final class SmsSignInConfirmFailure extends SmsSignInConfirmState {
  final String error;
  SmsSignInConfirmFailure(this.error);
}

final class SmsSignInConfirmLoading extends SmsSignInConfirmState {}
