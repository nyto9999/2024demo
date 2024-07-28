import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house/firestore/model/post.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/helper.dart';

//標題 地址 時間 金額 狀態
class OrderModel {
  final String? id;
  final Quote? quote;
  final Post? post;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    this.id,
    this.quote,
    this.post,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.empty() => OrderModel();

  Map<String, dynamic> toMap(ServerTimeStamp mapType) {
    return {
      'id': id,
      'quote': quote?.toMap(mapType),
      'post': post?.toMap(mapType),
      'status': status,
      'createdAt': mapType == ServerTimeStamp.yes
          ? FieldValue.serverTimestamp()
          : createdAt?.toIso8601String(),
      'updatedAt': mapType == ServerTimeStamp.yes
          ? FieldValue.serverTimestamp()
          : updatedAt?.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String?,
      quote: map['quote'] != null
          ? Quote.fromMap(map['quote'] as Map<String, dynamic>)
          : null,
      post: map['post'] != null
          ? Post.fromMap(map['post'] as Map<String, dynamic>)
          : null,
      status: map['status'] as String?,
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

  OrderModel copyWith({
    String? id,
    Quote? quote,
    Post? post,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      quote: quote ?? this.quote,
      post: post ?? this.post,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
