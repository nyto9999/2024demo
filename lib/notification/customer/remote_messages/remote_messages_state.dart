part of 'remote_messages_cubit.dart';

sealed class RemoteMessagesState extends Equatable {
  const RemoteMessagesState();

  @override
  List<Object> get props => [];
}

final class RemoteMessagesInitial extends RemoteMessagesState {}

final class RemoteMessagesLoaded extends RemoteMessagesState {
  final List<RemoteMessage> messages;

  const RemoteMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}
