part of 'txs_paginate.dart';

sealed class TxsPaginateState extends Equatable {
  const TxsPaginateState();

  @override
  List<Object> get props => [];
}

final class TxsPaginateInitial extends TxsPaginateState {}

final class TxsPaginating extends TxsPaginateState {
  final List<DocumentSnapshot> posts;
  final bool hasMore;

  const TxsPaginating({required this.posts, required this.hasMore});

  @override
  List<Object> get props => [posts, hasMore];
}
