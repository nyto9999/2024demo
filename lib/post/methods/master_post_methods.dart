import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house/firestore/model/post.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/main.dart';

class PostMasterMethods {
  Future<QuerySnapshot<Map<String, dynamic>>> getPostsExcludingMasterSelf({
    String? uid, //設定師傅不會看到自己的貼文
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) {
    return firestoreRepo.getPostsExcludingMasterSelf(
        uid: uid, lastDocument: lastDocument, pageSize: pageSize);
  }

  Stream<Post> getPostById(String postId) {
    return firestoreRepo.getPostById(postId).map((doc) {
      if (doc == null) return Post.empty();
      return Post.fromMap(doc);
    });
  }

  
}
