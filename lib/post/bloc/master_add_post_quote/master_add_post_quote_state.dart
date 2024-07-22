part of 'master_add_post_quote_cubit.dart';

sealed class MasterAddPostQuoteState extends Equatable {
  const MasterAddPostQuoteState();

  @override
  List<Object> get props => [];
}

final class MasterAddPostQuoteInitial extends MasterAddPostQuoteState {}

final class MasterAddPostQuoteLoading extends MasterAddPostQuoteState {}

final class MasterAddPostQuoteSuccess extends MasterAddPostQuoteState {}

final class MasterAddPostQuoteError extends MasterAddPostQuoteState {
  final String message;

  const MasterAddPostQuoteError(this.message);

  @override
  List<Object> get props => [message];
}
