import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:house/firestore/firestore_repo.dart';
import 'package:house/firestore/pagination.dart';
import 'package:house/main.dart';

part 'customer_notification_paginate_state.dart';

class CustomerNotificationPaginate
    extends Cubit<CustomerNotificationPaginateState> {
  final FireStoreRepo repo;
  final Pagination pagination;
  String uid;

  CustomerNotificationPaginate()
      : uid = auth.currentUser!.uid,
        pagination = Pagination(pageSize: 10),
        repo = firestoreRepo,
        super(CustomerNotificationPaginateInitial());

  void paginate() {
    debugPrint('paginate messages');

    // function
    pagination.paginateUntilMax((lastDocument) {
      return repo.paginateMessages(
        uid: uid,
        lastDocument: lastDocument,
        pageSize: pagination.pageSize,
      );
    });

  
  }

  @override
  Future<void> close() {
    pagination.dispose();
    return super.close();
  }
}
