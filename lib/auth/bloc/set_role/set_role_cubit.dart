import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house/auth/auth_repo.dart';

part 'set_role_state.dart';

class SetRoleCubit extends Cubit<SetRoleState> {
  final BuildContext context;
 

  SetRoleCubit(this.context) : super(SetRoleInitial());

  Future<void> updateRole(String newRole) async {
 

    emit(SetRoleLoading());

    try {
      // function
      await context.read<AuthRepo>().updateUserRole(newRole);
      emit(SetRoleSuccess());
    } catch (e) {
      emit(SetRoleFailure(e.toString()));
    }
  }
}
