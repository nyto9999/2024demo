part of 'add_tx_quote_pressed.dart';

sealed class AddTxQuotePressedState extends Equatable {
  const AddTxQuotePressedState();

  @override
  List<Object> get props => [];
}

final class AddTxQuotePressedInitial extends AddTxQuotePressedState {}

final class AddTxQuotePressedLoading extends AddTxQuotePressedState {}

final class AddTxQuotePressedSuccess extends AddTxQuotePressedState {}

final class AddTxQuotePressedError extends AddTxQuotePressedState {
  final String message;

  const AddTxQuotePressedError(this.message);

  @override
  List<Object> get props => [message];
}
