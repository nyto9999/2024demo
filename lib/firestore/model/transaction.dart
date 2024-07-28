import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/helper.dart';

// 大約 300 bytes / 1024 = 0.29 KB
class Tx {
  final String? id;
  final String? customerName;
  final String? postDesc;
  final String? customerId;
  final String? masterId;
  final String? masterName;
  final String? kind;
  final String? postStatus; // 付款完成后的状态
  final String? address;
  final DateTime? workDate; // 施工日期
  final String? workStatus; // 上架贴文后的状态，例如：paying, paid, pending
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Quote? confirmedQuote; //model 用
  final bool? reviewed;

  Tx({
    this.id,
    this.customerName,
    this.postDesc,
    this.customerId,
    this.masterId,
    this.masterName,
    this.kind,
    this.postStatus,
    this.address,
    this.workDate,
    this.workStatus,
    this.createdAt,
    this.updatedAt,
    this.confirmedQuote,
    this.reviewed,
  });

  factory Tx.empty() => Tx();

  // 转换为 Map 以便 Firestore 使用
  Map<String, dynamic> toMap(ServerTimeStamp mapType) {
    return {
      'id': id,
      'customerName': customerName,
      'postDesc': postDesc,
      'customerId': customerId,
      'masterId': masterId,
      'masterName': masterName,
      'kind': kind,
      'postStatus': postStatus,
      'address': address,
      'workDate': workDate != null ? Timestamp.fromDate(workDate!) : null,
      'workStatus': workStatus,
      'createdAt': mapType == ServerTimeStamp.yes
          ? FieldValue.serverTimestamp()
          : (createdAt != null ? Timestamp.fromDate(createdAt!) : null),
      'updatedAt': mapType == ServerTimeStamp.yes
          ? FieldValue.serverTimestamp()
          : (updatedAt != null ? Timestamp.fromDate(updatedAt!) : null),
      'confirmedQuote': confirmedQuote?.toMap(mapType),
      'reviewed': reviewed,
    };
  }

  // 从 Map 创建 TransactionModel 实例
  factory Tx.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return Tx();
    }
    return Tx(
      id: map['id'] as String?,
      customerName: map['customerName'] as String?,
      masterId: map['masterId'] as String?,
      masterName: map['masterName'] as String?,
      postDesc: map['postDesc'] as String?,
      customerId: map['customerId'] as String?,
      kind: map['kind'] as String?,
      postStatus: map['postStatus'] as String?,
      address: map['address'] as String?,
      workDate: map['workDate'] != null
          ? (map['workDate'] is Timestamp
              ? (map['workDate'] as Timestamp).toDate()
              : DateTime.parse(map['workDate'] as String))
          : null,
      workStatus: map['workStatus'] as String?,
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
      confirmedQuote: map['confirmedQuote'] != null
          ? Quote.fromMap(map['confirmedQuote'] as Map<String, dynamic>)
          : null,
      reviewed: map['reviewed'] as bool?,
    );
  }

  @override
  String toString() {
    return 'Tx(id: $id, customerName: $customerName, masterId: $masterId, masterName: $masterName, postDesc: $postDesc, customerId: $customerId, kind: $kind, postStatus: $postStatus, address: $address, workDate: $workDate, workStatus: $workStatus, createdAt: $createdAt, updatedAt: $updatedAt, confirmedQuote: $confirmedQuote, reviewed: $reviewed)';
  }

  Tx copyWith({
    String? id,
    String? customerName,
    String? masterId,
    String? masterName,
    String? postDesc,
    String? customerId,
    String? kind,
    String? postStatus,
    String? address,
    DateTime? workDate,
    String? workStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    Quote? confirmedQuote,
    bool? reviewed,
  }) {
    return Tx(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      masterId: masterId ?? this.masterId,
      masterName: masterName ?? this.masterName,
      postDesc: postDesc ?? this.postDesc,
      customerId: customerId ?? this.customerId,
      kind: kind ?? this.kind,
      postStatus: postStatus ?? this.postStatus,
      address: address ?? this.address,
      workDate: workDate ?? this.workDate,
      workStatus: workStatus ?? this.workStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      confirmedQuote: confirmedQuote ?? this.confirmedQuote,
      reviewed: reviewed ?? this.reviewed,
    );
  }

  factory Tx.fromJson(String source) =>
      Tx.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson(ServerTimeStamp type) => json.encode(toMap(type));
}
