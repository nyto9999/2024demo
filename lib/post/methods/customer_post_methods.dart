import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house/firestore/model/post.dart';
import 'package:house/main.dart';

class PostCustomerMethods {
  PostCustomerMethods();

  Future<void> addPost({
    required String kind,
    required String title,
  }) {
    final user = auth.currentUser;

    final post = Post(
      owner: user?.uid,
      name: user?.displayName,
      kind: kind,
      title: title,
      status: 'pending',
    );

    return firestoreRepo.addPost(post: post);
  }

  Stream<QuerySnapshot> getPostsByKind(String kind) =>
      firestoreRepo.getPostsByKind(kind);

  Stream<QuerySnapshot<Map<String, dynamic>>> myPostsStream() =>
      firestoreRepo.myPostsStream();

  Future<QuerySnapshot<Map<String, dynamic>>> getPostsByUserId({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
    String? uid,
  }) {
    return firestoreRepo.getPostsByUserId(
      lastDocument: lastDocument,
      pageSize: pageSize,
      uid: uid,
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostQuotes(String postId) {
    return firestoreRepo.getPostQuotes(postId);
  }
}
