part of 'my_txs_paginate.dart';

sealed class CustomerMyTxsPaginateState extends Equatable {
  const CustomerMyTxsPaginateState();

  @override
  List<Object> get props => [];
}

class CustomerMyTxsPaginateInitial extends CustomerMyTxsPaginateState {}

class CustomerMyTxsPaginating extends CustomerMyTxsPaginateState {
  final List<DocumentSnapshot> txs;
  final bool hasMore;

  const CustomerMyTxsPaginating({required this.txs, required this.hasMore});

  @override
  List<Object> get props => [txs, hasMore];
}
