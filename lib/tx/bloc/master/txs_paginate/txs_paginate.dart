import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:house/firestore/firestore_repo.dart';
import 'package:house/firestore/pagination.dart';
import 'package:house/main.dart';

part 'txs_paginate_state.dart';

//master
class TxsPaginate extends Cubit<TxsPaginateState> {
  final FireStoreRepo repo;
  final Pagination pagination;
  final String uid;

  TxsPaginate()
      : uid = auth.currentUser?.uid ?? '',
        pagination = Pagination(pageSize: 10),
        repo = firestoreRepo,
        super(TxsPaginateInitial()) {
    _init(uid);
  }

  void _init(String uid) {
    // function
    pagination.paginateUntilMax((lastDocument) {
      return repo.paginateMasterTxs(
        uid: uid,
        lastDocument: lastDocument,
        pageSize: pagination.pageSize,
      );
    });

    pagination.stream.listen((posts) {
      emit(TxsPaginating(posts: posts, hasMore: pagination.hasMore));
    });
  }

  Future<void> refreshTransactions() async {
    await pagination.refresh();
    _init(uid);
  }

  @override
  Future<void> close() {
    pagination.dispose();
    return super.close();
  }
}
