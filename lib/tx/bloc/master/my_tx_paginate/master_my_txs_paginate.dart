import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:house/firestore/firestore_repo.dart';
import 'package:house/firestore/pagination.dart';
import 'package:house/main.dart';

part 'master_my_txs_paginate_state.dart';

class MasterMyTxsPaginate extends Cubit<MasterMyTxsPaginateState> {
  final FireStoreRepo repo;
  final Pagination pagination;
  String uid;

  MasterMyTxsPaginate()
      : uid = auth.currentUser!.uid,
        pagination = Pagination(pageSize: 10),
        repo = FireStoreRepo(),
        super(MasterMyTxsPaginateInitial());

  void paginateBy(String? text) {
    debugPrint('m_paginateBy $text');

    //function
    pagination.paginateUntilMax((lastDocument) {
      return repo.paginateMasterMyTxs(
          tabText: text,
          masterId: uid,
          lastDocument: lastDocument,
          pageSize: pagination.pageSize);
    });

    pagination.stream.listen((txs$) {
      emit(MasterMyTxPaginating(txs: txs$, hasMore: pagination.hasMore));
      debugPrint('已經加載了 ${txs$.length} 條數據');
    });
  }
}
