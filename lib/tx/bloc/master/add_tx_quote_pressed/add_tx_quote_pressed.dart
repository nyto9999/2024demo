import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:house/firestore/exception/post_exception.dart';
import 'package:house/firestore/firestore_repo.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/main.dart';

part 'add_tx_quote_pressed_state.dart';

class AddTxQuotePressed extends Cubit<AddTxQuotePressedState> {
  final FireStoreRepo repo;

  AddTxQuotePressed()
      : repo = firestoreRepo,
        super(AddTxQuotePressedInitial());

  Future<void> addQuote({
    required String txId,
    required String? customerId,
    required int quoteAmount,
  }) async {
    final uid = auth.currentUser!.uid;

    if (uid == customerId) {
      emit(const AddTxQuotePressedError('不能對自己的貼文報價'));
      return;
    }

    try {
      emit(AddTxQuotePressedLoading());
      final Quote quote = Quote(
        txId: txId,
        masterId: uid,
        masterName: auth.currentUser?.displayName,
        quoteAmount: quoteAmount,
      );
      //function
      await firestoreRepo.addQuote(quote: quote);

 

      emit(AddTxQuotePressedSuccess());
    } on PostStatusException catch (e) {
      EasyLoading.showError(e.message);
    } catch (e) {
      emit(AddTxQuotePressedError(e.toString()));
    }
  }
 
}
