part of 'master_my_txs_paginate.dart';

sealed class MasterMyTxsPaginateState extends Equatable {
  const MasterMyTxsPaginateState();

  @override
  List<Object> get props => [];
}

final class MasterMyTxsPaginateInitial extends MasterMyTxsPaginateState {}

class MasterMyTxPaginating extends MasterMyTxsPaginateState {
  final List<DocumentSnapshot> txs;
  final bool hasMore;

  const MasterMyTxPaginating({required this.txs, required this.hasMore});

  @override
  List<Object> get props => [txs, hasMore];
}
