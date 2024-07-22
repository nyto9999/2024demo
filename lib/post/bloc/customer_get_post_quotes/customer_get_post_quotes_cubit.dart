import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:house/post/post_repo.dart';

part 'customer_get_post_quotes_state.dart';

class CustomerGetPostQuotesCubit extends Cubit<CustomerGetPostQuotesState> {
  final PostRepo postRepo;

  CustomerGetPostQuotesCubit(this.postRepo)
      : super(CustomerGetPostQuotesInitial());

  Future<void> getPostQuotes(String postId) async {
    try {
      emit(CustomerGetPostQuotesLoading());

      //function
      QuerySnapshot<Map<String, dynamic>> quotesSnapshot =
          await postRepo.customer.getPostQuotes(postId);

      emit(CustomerGetPostQuotesLoaded(quotesSnapshot.docs));
    } catch (e) {
      emit(CustomerGetPostQuotesError(e.toString()));
    }
  }
}
