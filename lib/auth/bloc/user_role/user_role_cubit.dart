import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house/auth/bloc/user_role/user_role_state.dart';
import 'package:house/firestore/firestore_repo.dart';
import 'package:house/firestore/model/user_role.dart';
import 'package:house/main.dart';

class UserRoleCubit extends Cubit<UserRoleState> {
  final FireStoreRepo repo;
  StreamSubscription<UserRoleModel?>? _subscription;
   

  UserRoleCubit() : repo =  firestoreRepo, super(UserRoleState(null));

  void init() {
    //function
    _subscription = repo.userRoleStream().listen((event) {
      emit(UserRoleState(event));
    });
  }

  bool isMaster() {
    final result =
        state.model?.canBeMaster == true && state.model?.role == 'master';

    return result;
  }

  @override
  Future<void> close() {
    debugPrint('close user role cubit');
    _subscription?.cancel();
    return super.close();
  }
}
