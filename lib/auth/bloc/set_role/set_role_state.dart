part of 'set_role_cubit.dart';

@immutable
sealed class SetRoleState {}

final class SetRoleInitial extends SetRoleState {}

final class SetRoleLoading extends SetRoleState {}

final class SetRoleSuccess extends SetRoleState {}

final class SetRoleFailure extends SetRoleState {
  final String error;
  SetRoleFailure(this.error);
}
