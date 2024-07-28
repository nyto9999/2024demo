part of 'tx_qoutes_stream.dart';

sealed class TxQoutesStreamState extends Equatable {
  const TxQoutesStreamState();

  @override
  List<Object> get props => [];
}

final class TxQoutesStreamInitial extends TxQoutesStreamState {}

final class TxQoutesStreamLoading extends TxQoutesStreamState {}

final class TxQoutesStreamingData extends TxQoutesStreamState {
  final List<Quote> quotes;

  const TxQoutesStreamingData(this.quotes);

  @override
  List<Object> get props => [quotes];
}

final class TxQoutesStreamError extends TxQoutesStreamState {
  final String message;

  const TxQoutesStreamError(this.message);

  @override
  List<Object> get props => [message];
}
