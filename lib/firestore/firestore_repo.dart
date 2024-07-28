import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:house/firestore/exception/exist_exception.dart';
import 'package:house/firestore/model/transaction.dart';
import 'package:house/helper/const.dart';
import 'package:house/firestore/exception/post_exception.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/firestore/model/user_role.dart';
import 'package:house/helper.dart';
import 'package:house/main.dart';
import 'package:house/router/router.dart';

class FireStoreRepo {
  static final FireStoreRepo _instance = FireStoreRepo._internal();
  FireStoreRepo._internal();
  factory FireStoreRepo() => _instance;

  ///[UserRole]
  ///
  ///
  Future<String?> getUserRoleById(String? uid) async {
    debugPrint('getUserRoleById $uid');
    if (uid == null) {
      throw UnauthorizedException('用戶沒有uid');
    }

    final userRoleDoc = store.collection(Const.userRoles).doc(uid);

    try {
      final doc = await userRoleDoc.get();

      // 如果文档不存在，设置默认角色为 'customer'
      if (doc.exists == false) {
        debugPrint('write role customer to firestore');
        await userRoleDoc.set({'role': 'customer'});
        return 'customer';
      } else {
        // 如果文档存在，返回角色
        final data = doc.data();
        if (data != null && data.containsKey('role')) {
          return data['role'] as String?;
        } else {
          throw Exception('Role data is missing or null');
        }
      }
    } catch (e) {
      debugPrint('Failed to get user role: $e');
      throw Exception('Failed to get user role');
    }
  }

  Stream<UserRoleModel?> userRoleStream() {
    final uid = auth.currentUser?.uid;

    final userRoleDoc = store.collection(Const.userRoles).doc(uid);

    return userRoleDoc.snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      } else {
        return UserRoleModel.fromMap(doc.data()!);
      }
    }).handleError((error) {
      debugPrint('Error fetching user role: $error');
      return null;
    });
  }

  Future<void> updateUserRole(String? uid, String newRole) async {
    if (uid == null) throw '用戶沒有uid';

    final userRoleDoc = store.collection(Const.userRoles).doc(uid);
    await userRoleDoc.update({'role': newRole});

    routerConfigNotifier.updateRoleAndConfig(newRole: newRole);
  }

  ///[Transactions]
  ///
  ///
  Stream<Tx> streamTransaction(String transactionId) => store
          .collection(Const.transactions)
          .doc(transactionId)
          .snapshots()
          .map((doc) {
        return Tx.fromMap(doc.data());
      });

  //
  Future<QuerySnapshot<Map<String, dynamic>>> paginateMasterTxs({
    required String uid, //設定師傅不會看到自己的貼文
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) {
    Query<Map<String, dynamic>> query = store
        .collection(Const.transactions)
        .where(Const.postStatus, isEqualTo: Const.pending)
        .orderBy(Const.createdAt)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  Future<void> addTransaction({
    required Tx transaction,
  }) async {
    final ref = store.collection(Const.transactions).doc();

    await ref.set(transaction.copyWith(id: ref.id).toMap(ServerTimeStamp.no));
  }

  Future<void> updateTxPostStatus({
    required String transactionId,
    required String status,
  }) async {
    final transactionRef =
        store.collection(Const.transactions).doc(transactionId);

    await transactionRef.update({'postStatus': status});
  }

  Future<void> updateTxReviewed({
    required String transactionId,
    bool reviewed = true,
  }) async {
    final transactionRef =
        store.collection(Const.transactions).doc(transactionId);

    await transactionRef.update({'reviewed': reviewed});
  }

  Future<QuerySnapshot<Map<String, dynamic>>> paginateCustomerMyTxs({
    required String? tabText,
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
    required String customerId,
  }) {
    Query<Map<String, dynamic>>? baseQuery = queryMap[tabText];

    if (baseQuery == null) {
      throw ArgumentError('Invalid tab text: $tabText');
    }

    baseQuery.limit(pageSize);

    if (lastDocument != null) {
      baseQuery = baseQuery.startAfterDocument(lastDocument);
    }

    return baseQuery.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> paginateMasterMyTxs({
    required String? tabText,
    required String masterId,
    DocumentSnapshot<Object?>? lastDocument,
    required int pageSize,
  }) {
    Query<Map<String, dynamic>>? baseQuery = queryMap[tabText];
    if (baseQuery == null) {
      throw ArgumentError('Invalid tab text: $tabText');
    }
    baseQuery =
        baseQuery.where('masterId', isEqualTo: masterId).limit(pageSize);

    if (lastDocument != null) {
      baseQuery = baseQuery.startAfterDocument(lastDocument);
    }

    return baseQuery.get();
  }

  Future<void> updateTxWorkStatus({
    required String transactionId,
    required String status,
  }) async {
    final transactionRef =
        store.collection(Const.transactions).doc(transactionId);

    await transactionRef.update({'workStatus': status});
  }

  ///[Reviews]
  ///
  ///
  Future<void> addReview({
    required String masterId,
    required String transactionId,
    required String review,
    required int rating,
  }) async {
    final reviewRef = store.collection(Const.reviews).doc();

    await reviewRef.set({
      'id': reviewRef.id,
      'masterId': masterId,
      'transactionId': transactionId,
      'review': review,
      'rating': rating,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 更新師父的平均評分
  Future<void> updateMasterRating({
    required String masterId,
    required int rating,
  }) async {
    final masterRef = store.collection(Const.userRoles).doc(masterId);
    final masterDoc = await masterRef.get();

    final data = masterDoc.data()!;
    final currentAvgRating = data['avgRating'] ?? 0.0;
    final currentCount = data['ratingCount'] ?? 0;

    final newCount = currentCount + 1;
    final double newAvgRating =
        ((currentAvgRating * currentCount) + rating) / newCount;

    await masterRef.update({
      'avgRating': newAvgRating,
      'ratingCount': newCount,
    });
  }

  ///[Quotes]
  ///
  ///
  Future<void> addQuote({
    required Quote quote,
  }) async {
    // 取得帖子引用
    DocumentReference txRef =
        store.collection(Const.transactions).doc(quote.txId);
    CollectionReference txQoutesRef = txRef.collection(Const.quotes);

    // 获取帖子状态
    DocumentSnapshot txSnapshot = await txRef.get();
    final status =
        (txSnapshot.data() as Map<String, dynamic>)['postStatus'] as String?;

    if (status == 'paid') {
      throw PostStatusException('客人已付款，無法報價。');
    }
    if (status == 'paying') {
      throw PostStatusException('客人正在付款，無法報價。');
    }

    // 查询是否已经存在该 masterId 的报价
    QuerySnapshot existingQuotes = await txQoutesRef
        .where('masterId', isEqualTo: quote.masterId)
        .limit(1)
        .get();

    if (existingQuotes.docs.isNotEmpty) {
      // 更新已有的报价
      DocumentReference existingQuoteRef = existingQuotes.docs.first.reference;
      await existingQuoteRef.update({
        'txId': quote.txId,
        'quoteAmount': quote.quoteAmount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // 新增新的报价
      final newQuoteRef = txQoutesRef.doc();
      await newQuoteRef.set(
        quote.copyWith(id: newQuoteRef.id).toMap(ServerTimeStamp.yes),
      );
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMasterQuotesByTxId({
    required String transactionId,
    required String masterId,
  }) {
    return store
        .collection(Const.transactions)
        .doc(transactionId)
        .collection(Const.quotes)
        .where('masterId', isEqualTo: masterId)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamTxQuotes(
      String transactionId) {
    return store
        .collection(Const.transactions)
        .doc(transactionId)
        .collection(Const.quotes)
        .snapshots();
  }

  Future<void> updateTxAfterPayment({
    required Tx tx,
  }) async {
    final txRef = store.collection(Const.transactions).doc(tx.id);

    await txRef.update(tx.toMap(ServerTimeStamp.yes));
  }

  /// [General]
  ///
  ///
  Future<QuerySnapshot<Map<String, dynamic>>> getServiceKinds() {
    return store.collection(Const.serviceKind).get();
  }

  Future<void> addMasterApplication({
    required String name,
  }) async {
    final uid = auth.currentUser!.uid;

    final existingApplications = await store
        .collection(Const.masterApplications)
        .where('uid', isEqualTo: uid)
        .get();

    if (existingApplications.docs.isNotEmpty) {
      // 如果已有申请，则更新最新的申请
      final existingDoc = existingApplications.docs.first;
      existingDoc.reference.update({
        'name': name,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      // 如果没有现有申请，则创建一个新的
      final newApplicationRef =
          store.collection(Const.masterApplications).doc();

      final newApplication = {
        'id': newApplicationRef.id,
        'uid': uid,
        'name': name,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await newApplicationRef.set(newApplication);
    }
  }

  //get fcm token

  Future<String> getFcmToken(String uid) async {
    final userRoleDoc = store.collection(Const.userRoles).doc(uid);
    final doc = await userRoleDoc.get();
    final data = doc.data();
    if (data != null && data.containsKey('fcmToken')) {
      return data['fcmToken'] as String;
    } else {
      throw Exception('fcmToken is missing or null');
    }
  }
}

final now = DateTime.now();
final startOfDay = DateTime(now.year, now.month, now.day); // 今天的開始
final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59); // 今天的結束

Map<String?, Query<Map<String, dynamic>>> queryMap = {
  //Customer
  '張貼中': store
      .collection(Const.transactions)
      .where('postStatus', isEqualTo: 'pending')
      .where('customerId', isEqualTo: auth.currentUser!.uid)
      .orderBy('createdAt', descending: true)
      .limit(10),

  '已付款': store
      .collection(Const.transactions)
      .where('customerId', isEqualTo: auth.currentUser!.uid)
      .where('postStatus', isEqualTo: 'paid')
      .where('workStatus', isEqualTo: 'undone')
      .orderBy('workDate', descending: true)
      .limit(10),
  '已結案': store
      .collection(Const.transactions)
      .where('customerId', isEqualTo: auth.currentUser!.uid)
      .where('postStatus', isEqualTo: 'paid')
      .where('workStatus', isEqualTo: 'done')
      .orderBy('workDate', descending: true)
      .limit(10),

  //Master
  '工作清單': store
      .collection(Const.transactions)
      .where('postStatus', isEqualTo: 'paid')
      .where('workStatus', isEqualTo: 'undone')
      .orderBy('workDate', descending: true)
      .limit(10),
  '今天工作': store
      .collection(Const.transactions)
      .where('postStatus', isEqualTo: 'paid')
      .where('workStatus', isEqualTo: 'undone')
      .where('workDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .where('workDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
      .orderBy('workDate', descending: true)
      .limit(10),
  '已完成': store
      .collection(Const.transactions)
      .where('postStatus', isEqualTo: 'paid')
      .where('workStatus', isEqualTo: 'done')
      .orderBy('workDate', descending: true)
      .limit(10),
};
