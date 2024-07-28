part of 'qoute_stream.dart';

sealed class QouteStreamState extends Equatable {
  const QouteStreamState();

  @override
  List<Object> get props => [];
}

final class QouteStreamInitial extends QouteStreamState {}

final class QouteStreamLoading extends QouteStreamState {}

final class QouteStreamData extends QouteStreamState {
  final Quote qoute;

  const QouteStreamData(this.qoute);

  @override
  List<Object> get props => [qoute];
}

final class QouteStreamError extends QouteStreamState {
  final String message;

  const QouteStreamError(this.message);

  @override
  List<Object> get props => [message];
}
