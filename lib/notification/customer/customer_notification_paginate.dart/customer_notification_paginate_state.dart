part of 'customer_notification_paginate_cubit.dart';

sealed class CustomerNotificationPaginateState extends Equatable {
  const CustomerNotificationPaginateState();

  @override
  List<Object> get props => [];
}

final class CustomerNotificationPaginateInitial extends CustomerNotificationPaginateState {}

//paginating

final class CustomerNotificationPaginating extends CustomerNotificationPaginateState {
  final List<DocumentSnapshot> messages;
  final bool hasMore;

  const CustomerNotificationPaginating({required this.messages, required this.hasMore});

  @override
  List<Object> get props => [messages, hasMore];
}

