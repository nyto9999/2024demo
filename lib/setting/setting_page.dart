import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/auth_repo.dart';
import 'package:house/auth/bloc/user_role/user_role_state.dart';
import 'package:house/auth/widgets/set_role_button.dart';
import 'package:house/const.dart';

import 'package:house/main.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    debugPrint('build setting');

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<UserRoleCubit, UserRoleState>(
          builder: (context, state) {
            return Text('當前用戶角色 : ${state.model?.role}');
          },
        ),
      ),
      body: BlocBuilder<UserRoleCubit, UserRoleState>(
        builder: (context, state) {
          final userRole = state.model?.role;
          final isMaster = state.model?.canBeMaster ?? false;
          return Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    auth.currentUser?.updateDisplayName('陳宇亘');
                  },
                  child: const Text('reset')),
              if (userRole == 'customer' && isMaster)
                const SetRoleButton(
                  role: 'master',
                  successMessage: '成功更改為客人',
                  failureMessage: '已經是師傅',
                ),
              if (userRole != 'customer')
                const SetRoleButton(
                  role: 'customer',
                  successMessage: '成功更改為師傅',
                  failureMessage: '已經是客人',
                ),
              if (!isMaster)
                ElevatedButton(
                  onPressed: () {
                    context.push('/setting/${Const.master_application}');
                  },
                  child: const Text('成為師傅'),
                ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      debugPrint('${auth.currentUser}');
                    },
                    child: const Text('user')),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthRepo>().authMethods.signOut(context);
                },
                child: const Text('登出'),
              ),
            ],
          );
        },
      ),
    );
  }
}
