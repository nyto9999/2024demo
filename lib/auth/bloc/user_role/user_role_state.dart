import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
 

import 'package:house/auth/auth_repo.dart';
import 'package:house/firestore/model/user_role.dart';
import 'package:house/router/initial_routing/initial_routing_config.dart';
import 'package:house/router/router.dart';

class UserRoleState extends Equatable {
  final UserRoleModel? model;

  const UserRoleState(this.model);

  @override
  List<Object?> get props => [model?.role, model?.canBeMaster];
}

class UserRoleCubit extends Cubit<UserRoleState> {
  final AuthRepo authRepo;
  StreamSubscription<UserRoleModel?>? _subscription;

  UserRoleCubit(this.authRepo) : super(const UserRoleState(null)) {
    _init();
  }

  void _init() {
    //function
    _subscription = authRepo.userRoleStream().listen((model) {
      if (model == null) {
        routerConfigNotifier.value = initialRoutingConfig();
      }
      // 仅当 model 发生变化时才发射新的状态
      if (state.model != model) {
        emit(UserRoleState(model));
      }
    });
  }

  bool hasMasterPermission() {
    final result =
        state.model?.canBeMaster == true && state.model?.role == 'master';

    return result;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
