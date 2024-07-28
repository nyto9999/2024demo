import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:house/firestore/firestore_repo.dart';
import 'package:house/firestore/pagination.dart';
import 'package:house/main.dart';
part 'my_txs_paginate_state.dart';

class CustomerMyTxsPaginate extends Cubit<CustomerMyTxsPaginateState> {
  final FireStoreRepo repo;
  final Pagination pagination;
  String uid;

  CustomerMyTxsPaginate()
      : uid = auth.currentUser!.uid,
        pagination = Pagination(pageSize: 10),
        repo = firestoreRepo,
        super(CustomerMyTxsPaginateInitial());

  void paginateBy(String? text) {
    debugPrint('c_paginateBy $text');

    pagination.paginateUntilMax((lastDocument) {
      // function
      return repo.paginateCustomerMyTxs(
          tabText: text,
          customerId: uid,
          lastDocument: lastDocument,
          pageSize: pagination.pageSize);
    });

    pagination.stream.listen((txs$) {
      emit(CustomerMyTxsPaginating(txs: txs$, hasMore: pagination.hasMore));
      debugPrint('已經加載了 ${txs$.length} 條數據');
    });
  }

  @override
  Future<void> close() {
    pagination.dispose();
    return super.close();
  }
}
