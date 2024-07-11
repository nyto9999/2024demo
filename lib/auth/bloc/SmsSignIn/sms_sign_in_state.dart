part of 'sms_sign_in_cubit.dart';

@immutable
sealed class SmsSignInState {}

final class SmsSignInInitial extends SmsSignInState {}

final class SmsSignInLoading extends SmsSignInState {}

final class SmsSignInSuccess extends SmsSignInState {}

final class SmsSignInFailure extends SmsSignInState {
  final String error;
  SmsSignInFailure(this.error);
}

final class SmsSignInCodeSent extends SmsSignInState {}
final class SmsSignInConfirmationSent extends SmsSignInState {}

final class InvalidSmsSignInForm extends SmsSignInState {}
