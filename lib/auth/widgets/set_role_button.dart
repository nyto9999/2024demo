import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:house/auth/bloc/set_role/set_role_cubit.dart';
import 'package:house/auth/helper/custom_style.dart';

class SetRoleButton extends StatelessWidget {
  final String role;
  final String successMessage;
  final String failureMessage;

  const SetRoleButton({
    super.key,
    required this.role,
    required this.successMessage,
    required this.failureMessage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetRoleCubit(context),
      child: BlocConsumer<SetRoleCubit, SetRoleState>(
        listener: (context, state) {
          if (state is SetRoleLoading) {
            EasyLoading.show(status: '更改中...');
          } else if (state is SetRoleSuccess) {
            EasyLoading.showSuccess(successMessage);
          } else if (state is SetRoleFailure) {
            EasyLoading.showInfo(failureMessage);
          }
        },
        builder: (context, state) {
          return Custom.defaultButton(
            onPressed: () {
              context.read<SetRoleCubit>().updateRole(role);
            },
            child: const Text('切換帳號'),
          );
        },
      ),
    );
  }
}
