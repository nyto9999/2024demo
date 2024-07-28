import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/main.dart';

part 'qoute_stream_state.dart';

//master tx ops page
class QouteStream extends Cubit<QouteStreamState> {
  QouteStream()
      : masterId = auth.currentUser!.uid,
        super(QouteStreamInitial());

  final String masterId;

  void qouteStream(String txId) {
    emit(QouteStreamLoading());

    firestoreRepo
        .streamMasterQuotesByTxId(transactionId: txId, masterId: masterId)
        .listen(
      (quoteSnapshot) {
        for (var element in quoteSnapshot.docs) {
          emit(QouteStreamData(Quote.fromMap(element.data())));
        }
      },
      onError: (error) {
        emit(QouteStreamError(error.toString()));
      },
    );
  }
}
