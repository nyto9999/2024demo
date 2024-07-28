import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house/helper.dart';

class Quote {
  final String? id;
  final String? masterId;
  final String? masterName;
  final String? txId;
  final int? quoteAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Quote({
    this.id,
    this.masterId,
    this.masterName,
    this.quoteAmount,
    this.txId,
    this.createdAt,
    this.updatedAt,
  });

  factory Quote.empty() => Quote();

  @override
  String toString() =>
      'QuoteModel(id: $id, masterId: $masterId, masterName:$masterName quoteAmount: $quoteAmount, txId: $txId, createdAt: $createdAt, updatedAt: $updatedAt)';

  Map<String, dynamic> toMap(ServerTimeStamp mapType) {
    return {
      'id': id,
      'masterId': masterId,
      'masterName': masterName,
      'txId': txId,
      'quoteAmount': quoteAmount,
      'createdAt': mapType == ServerTimeStamp.yes
          ? FieldValue.serverTimestamp()
          : createdAt?.toIso8601String(),
      'updatedAt': mapType == ServerTimeStamp.yes
          ? FieldValue.serverTimestamp()
          : updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> updatePrice() {
    return {
      'quoteAmount': quoteAmount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] as String?,
      masterId: map['masterId'] != null ? map['masterId'] as String : '',
      masterName: map['masterName'] != null ? map['masterName'] as String : '',
      quoteAmount: map['quoteAmount'] != null ? map['quoteAmount'] as int : 0,
      txId: map['txId'] != null ? map['txId'] as String : '',
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

  String toJson(ServerTimeStamp type) => json.encode(toMap(type));

  factory Quote.fromJson(String source) =>
      Quote.fromMap(json.decode(source) as Map<String, dynamic>);

  Quote copyWith({
    String? id,
    String? masterId,
    String? masterName,
    int? quoteAmount,
    String? txId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quote(
      id: id ?? this.id,
      masterId: masterId ?? this.masterId,
      masterName: masterName ?? this.masterName,
      quoteAmount: quoteAmount ?? this.quoteAmount,
      txId: txId ?? this.txId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
