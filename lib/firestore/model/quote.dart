import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house/helper.dart';

class QuoteModel {
  final String? id;
  final String? masterId;
  final String? postId;
  final int? quoteAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuoteModel({
    this.id,
    this.masterId,
    this.quoteAmount,
    this.postId,
    this.createdAt,
    this.updatedAt,
  });

  // tostring

  @override
  String toString() =>
      'QuoteModel(id: $id, masterId: $masterId, quoteAmount: $quoteAmount, postId: $postId, createdAt: $createdAt, updatedAt: $updatedAt)';

  Map<String, dynamic> toMap(MapType mapType) {
    return {
      'id': id,
      'masterId': masterId,
      'postId': postId,
      'quoteAmount': quoteAmount,
      'createdAt': mapType == MapType.serverTimestamp
          ? FieldValue.serverTimestamp()
          : createdAt?.toIso8601String(),
      'updatedAt': mapType == MapType.serverTimestamp
          ? FieldValue.serverTimestamp()
          : updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'quoteAmount': quoteAmount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    return QuoteModel(
      id: map['id'] as String?,
      masterId: map['masterId'] != null ? map['masterId'] as String : '',
      quoteAmount: map['quoteAmount'] != null ? map['quoteAmount'] as int : 0,
      postId: map['postId'] != null ? map['postId'] as String : '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.parse(map['createdAt'] as String))
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] is Timestamp
              ? (map['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(map['updatedAt'] as String))
          : null,
    );
  }

  String toJson(MapType type) => json.encode(toMap(type));

  factory QuoteModel.fromJson(String source) =>
      QuoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  QuoteModel copyWith({
    String? id,
    String? masterId,
    int? quoteAmount,
    String? postId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      masterId: masterId ?? this.masterId,
      quoteAmount: quoteAmount ?? this.quoteAmount,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
