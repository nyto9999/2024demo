// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house/helper.dart';

class Post {
  final String? id;
  final String? name;
  final String? title;
  final String? owner;
  final String? kind;
  final String? status;
  final String? address;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Post.empty() => Post();

  Post({
    this.id,
    this.name,
    this.title,
    this.owner,
    this.kind,
    this.status,
    this.address,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap(ServerTimeStamp mapType) {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'title': title,
      'owner': owner,
      'kind': kind,
      'status': status,
      'address': address,
      'date': dateToTimestamp(date),
      'createdAt': dateToTimestamp(createdAt) ?? FieldValue.serverTimestamp(),
      'updatedAt': dateToTimestamp(updatedAt) ?? FieldValue.serverTimestamp(),
    };
  }

  Post copyWith({
    String? id,
    String? name,
    String? title,
    String? owner,
    String? kind,
    String? status,
    String? address, // 新增的字段
    DateTime? date, // 新增的字段
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      owner: owner ?? this.owner,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      address: address ?? this.address, // 新增的字段
      date: date ?? this.date, // 新增的字段
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Post.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return Post.empty();
    }
    return Post(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      owner: map['owner'] != null ? map['owner'] as String : null,
      kind: map['kind'] != null ? map['kind'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      address:
          map['address'] != null ? map['address'] as String : null, // 新增的字段
      date: timestampToDate(map, 'date'), // 新增的字段
      createdAt: timestampToDate(map, 'createdAt'),
      updatedAt: timestampToDate(map, 'updatedAt'),
    );
  }

  String toJson(ServerTimeStamp type) => json.encode(toMap(type));

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);
}
