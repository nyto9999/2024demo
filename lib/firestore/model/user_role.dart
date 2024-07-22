// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
class UserRoleModel {
  final String role;
  final bool canBeMaster;

  UserRoleModel({
    required this.role,
    required this.canBeMaster,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'canBeMaster': canBeMaster,
    };
  }

  factory UserRoleModel.fromMap(Map<String, dynamic> map) {
    return UserRoleModel(
      role: map['role'] ?? 'customer',
      canBeMaster: map['canBeMaster'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoleModel.fromJson(String source) =>
      UserRoleModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
