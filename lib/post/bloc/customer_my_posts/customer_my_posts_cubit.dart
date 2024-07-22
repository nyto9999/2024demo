import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:house/firestore/pagination.dart';
import 'package:house/main.dart';
import 'package:house/post/post_repo.dart';
part 'customer_my_posts_state.dart';

class CustomerMyPostsCubit extends Cubit<CustomerMyPostsState> {
  final PostRepo postRepo;
  final Pagination pagination;
  String? uid;

  CustomerMyPostsCubit(this.postRepo)
      : pagination = Pagination(pageSize: 10),
        super(CustomerMyPostsInitial()) {
    _init();
  }

  void _init() {
    uid = auth.currentUser?.uid;

    if (uid == null) return;

    // function
    pagination.paginateUntilMax((lastDocument) {
      return postRepo.customer.getPostsByUserId(
          uid: uid, lastDocument: lastDocument, pageSize: pagination.pageSize);
    });

    pagination.stream.listen((posts) {
      emit(
          CustomerMyPostsPaginating(posts: posts, hasMore: pagination.hasMore));
      debugPrint('已經加載了 ${posts.length} 條數據');
    });
  }

  @override
  Future<void> close() {
    pagination.dispose();
    return super.close();
  }
}
