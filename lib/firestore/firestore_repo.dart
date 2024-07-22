import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/methods/auth/auth_shared_methods.dart';
import 'package:house/const.dart';
import 'package:house/firestore/exception/exist_exception.dart';
import 'package:house/firestore/exception/post_exception.dart';
import 'package:house/firestore/model/post.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/firestore/model/user_role.dart';
import 'package:house/helper.dart';
import 'package:house/main.dart';
import 'package:house/router/router.dart';

class FireStoreRepo {
  static final FireStoreRepo _instance = FireStoreRepo._internal();
  FireStoreRepo._internal();
  factory FireStoreRepo() => _instance;

  Future<String?> getUserRoleById(String? uid) async {
    print('getUserRoleById $uid');
    if (uid == null) {
      throw UserNotFound('用戶沒有uid');
    }

    final userRoleDoc =
        FirebaseFirestore.instance.collection(Const.userRoles).doc(uid);

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
      print('Failed to get user role: $e');
      throw Exception('Failed to get user role');
    }
  }

  Stream<UserRoleModel?> userRoleStream() {
    final uid = auth.currentUser?.uid;

    final userRoleDoc = firestore.collection(Const.userRoles).doc(uid);

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

  Stream<Map<String, dynamic>?> getPostById(String postId) =>
      firestore.collection(Const.posts).doc(postId).snapshots().map((doc) {
        return doc.data();
      });

  /// [Master Post]

  Future<QuerySnapshot<Map<String, dynamic>>> getPostsExcludingMasterSelf({
    String? uid, //設定師傅不會看到自己的貼文
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) {
    debugPrint('getAllPosts $uid');
    Query<Map<String, dynamic>> query = firestore
        .collection(Const.posts)
        .where(Const.owner, isNotEqualTo: uid!)
        .orderBy(Const.createdAt)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  Future<void> updateUserRole(String? uid, String newRole) async {
    if (uid == null) throw '用戶沒有uid';

    final userRoleDoc = firestore.collection(Const.userRoles).doc(uid);
    await userRoleDoc.update({'role': newRole});

    routerConfigNotifier.updateRoleAndConfig(newRole: newRole);
  }

  /// [Customer Post]
  Stream<QuerySnapshot<Map<String, dynamic>>> myPostsStream() {
    final uid = auth.currentUser?.uid;

    if (uid == null) throw '用戶沒有uid';

    return firestore
        .collection('posts')
        .where('owner', isEqualTo: uid)
        .snapshots();
  }

  ///  firestore repo 分頁
  Future<QuerySnapshot<Map<String, dynamic>>> getPostsByUserId({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
    String? uid,
  }) async {
    Query<Map<String, dynamic>> query = firestore
        .collection('posts')
        .where('owner', isEqualTo: uid)
        .orderBy('createdAt')
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.get();
  }

  Stream<QuerySnapshot> getPostsByKind(String kind) {
    return firestore
        .collection(Const.posts)
        .where(Const.kind, isEqualTo: kind)
        .snapshots();
  }

  Future<void> addPost({
    required Post post,
  }) async {
    final postRef = firestore.collection(Const.posts).doc();

    await postRef
        .set(post.copyWith(id: postRef.id).toMap(MapType.serverTimestamp));
  }

  Future<void> updatePostStatus({
    required String postId,
    required String status,
  }) async {
    final postRef = firestore.collection(Const.posts).doc(postId);

    await postRef.update({'status': status});
  }

  /// [General]
  /// 服務項目
  Future<QuerySnapshot<Map<String, dynamic>>> getServiceKinds() {
    return firestore.collection(Const.serviceKind).get();
  }

  /// 師傅申請表
  Future<void> createMasterApplication({
    required String name,
  }) async {
    final uid = auth.currentUser!.uid;

    final existingApplications = await firestore
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
          firestore.collection(Const.masterApplications).doc();

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

  Future<void> addQuote({
    required QuoteModel quote,
  }) async {
    // 取得帖子引用
    DocumentReference postRef =
        firestore.collection(Const.posts).doc(quote.postId);
    CollectionReference quotesRef = postRef.collection(Const.quotes);

    // 获取帖子状态
    DocumentSnapshot postSnapshot = await postRef.get();
    final postStatus =
        (postSnapshot.data() as Map<String, dynamic>)['status'] as String?;

    if (postStatus == 'paid') {
      throw PostStatusException('客人已付款，無法報價。');
    }
    if (postStatus == 'paying') {
      throw PostStatusException('客人正在付款，無法報價。');
    }

    // 查询是否已经存在该 masterId 的报价
    QuerySnapshot existingQuotes = await quotesRef
        .where('masterId', isEqualTo: quote.masterId)
        .limit(1)
        .get();

    if (existingQuotes.docs.isNotEmpty) {
      // 更新已有的报价
      DocumentReference existingQuoteRef = existingQuotes.docs.first.reference;
      await existingQuoteRef.update({
        'postId': quote.postId,
        'quoteAmount': quote.quoteAmount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // 新增新的报价
      final newQuoteRef = quotesRef.doc();
      await newQuoteRef.set(
        quote.copyWith(id: newQuoteRef.id).toMap(MapType.serverTimestamp),
      );
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostQuotes(String postId) {
    return firestore
        .collection(Const.posts)
        .doc(postId)
        .collection(Const.quotes)
        .get();
  }

  Future<void> addOrder({
    required QuoteModel quote,
  }) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    print('addOrder ${quote.toString()}');
    // Using a transaction to ensure atomicity
    await firestore.runTransaction((transaction) async {
      // Get the reference to the post document
      DocumentReference postRef =
          firestore.collection(Const.posts).doc(quote.postId);
      CollectionReference ordersRef = firestore.collection(Const.orders);

      // Check if there's already an order for this post
      QuerySnapshot existingOrders = await ordersRef
          .where('postId', isEqualTo: quote.postId)
          .limit(1)
          .get();

      if (existingOrders.docs.isNotEmpty) {
        // If an order already exists, throw an exception
        throw ExistException();
      }

      // Update the post status to "paid"
      transaction.update(postRef, {'status': 'paid'});

      // Create a new order
      DocumentReference orderRef = ordersRef.doc();
      transaction.set(orderRef, {
        'id': orderRef.id,
        'masterId': quote.masterId,
        'customerId': auth.currentUser!.uid,
        'postId': quote.postId,
        'quoteId': quote.id,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
