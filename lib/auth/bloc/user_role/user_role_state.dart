import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:house/firestore/model/user_role.dart';

@immutable
// ignore: must_be_immutable
class UserRoleState extends Equatable {
  UserRoleModel? model;

  UserRoleState(this.model);

  @override
  List<Object?> get props => [model?.role, model?.canBeMaster];
}
