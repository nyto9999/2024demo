part of 'tx_stream.dart';

sealed class TxStreamState extends Equatable {
  const TxStreamState();

  @override
  List<Object> get props => [];
}

final class TxStreamInitial extends TxStreamState {}

final class TxStreamError extends TxStreamState {
  final String message;

  const TxStreamError(this.message);

  @override
  List<Object> get props => [message];
}

final class TxStreamLoading extends TxStreamState {}

final class TxEvent extends TxStreamState {
  final Tx tx;

  const TxEvent(this.tx);

  @override
  List<Object> get props => [tx];
}
