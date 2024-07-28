import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserRoleModel {
  final String? role;
  final bool? canBeMaster;
  final int? ratingCount;
  final double? avgRating;

  UserRoleModel({
    this.role,
    this.canBeMaster,
    this.ratingCount,
    this.avgRating,
  });

  factory UserRoleModel.empty() => UserRoleModel();

  //tostring

  @override
  String toString() =>
      'UserRoleModel(role: $role, canBeMaster: $canBeMaster, ratingCount: $ratingCount, avgRating: $avgRating)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'canBeMaster': canBeMaster,
      'ratingCount': ratingCount,
      'avgRating': avgRating,
    };
  }

  factory UserRoleModel.fromMap(Map<String, dynamic> map) {
    return UserRoleModel(
      role: map['role'] != null ? map['role'] as String : null,
      canBeMaster:
          map['canBeMaster'] != null ? map['canBeMaster'] as bool : null,

      ratingCount: map['ratingCount'] != null ? map['ratingCount'] as int : 0,
      avgRating: map['avgRating'] != null ? map['avgRating'] as double : 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoleModel.fromJson(String source) =>
      UserRoleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserRoleModel copyWith({
    String? role,
    bool? canBeMaster,
    int? ratingCount,
    double? avgRating,
  }) {
    return UserRoleModel(
      role: role ?? this.role,
      canBeMaster: canBeMaster ?? this.canBeMaster,
      ratingCount: ratingCount ?? this.ratingCount,
      avgRating: avgRating ?? this.avgRating,
    );
  }
}
