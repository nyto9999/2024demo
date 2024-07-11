part of 'email_sign_up_cubit.dart';

@immutable
sealed class EmailSignUpState {}

final class EmailSignUpInitial extends EmailSignUpState {}

final class EmailSignUpLoading extends EmailSignUpState {}

final class EmailSignUpSuccess extends EmailSignUpState {}

final class EmailSignUpFailure extends EmailSignUpState {
  final String error;
  EmailSignUpFailure(this.error);
}

final class InvalidSignUpForm extends EmailSignUpState {}


