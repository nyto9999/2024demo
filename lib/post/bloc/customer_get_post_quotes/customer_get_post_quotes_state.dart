part of 'customer_get_post_quotes_cubit.dart';

sealed class CustomerGetPostQuotesState extends Equatable {
  const CustomerGetPostQuotesState();

  @override
  List<Object> get props => [];
}

final class CustomerGetPostQuotesInitial extends CustomerGetPostQuotesState {}

final class CustomerGetPostQuotesLoading extends CustomerGetPostQuotesState {}

final class CustomerGetPostQuotesLoaded extends CustomerGetPostQuotesState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> quotes;

  const CustomerGetPostQuotesLoaded(this.quotes);

  @override
  List<Object> get props => [quotes];
}

final class CustomerGetPostQuotesError extends CustomerGetPostQuotesState {
  final String message;

  const CustomerGetPostQuotesError(this.message);

  @override
  List<Object> get props => [message];
}
