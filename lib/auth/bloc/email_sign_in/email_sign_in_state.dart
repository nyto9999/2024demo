part of 'email_sign_in_cubit.dart';

@immutable
sealed class EmailSignInState {}

final class EmailSignInInitial extends EmailSignInState {}

final class EmailSignInLoading extends EmailSignInState {}

final class EmailSignInSuccess extends EmailSignInState {}

final class EmailSignInFailure extends EmailSignInState {
  final String error;
  EmailSignInFailure(this.error);
}

final class InvalidSignInForm extends EmailSignInState {}

final class EmailNotVerified extends EmailSignInState {}
