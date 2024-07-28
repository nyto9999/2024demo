import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:house/firestore/firestore_repo.dart';
import 'package:house/firestore/model/quote.dart';

import 'package:house/main.dart';

part 'tx_qoutes_stream_state.dart';

/// Customer
class TxQoutesStream extends Cubit<TxQoutesStreamState> {
  final FireStoreRepo repo;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  TxQoutesStream()
      : repo = firestoreRepo,
        super(TxQoutesStreamInitial());

  void streamTransactionQuotes(String id) {
    emit(TxQoutesStreamLoading());

    _subscription = repo.streamTxQuotes(id).listen(
      (quotesSnapshot) {
        // 将 QuerySnapshot 转换为 Quote 模型列表
        List<Quote> quotes = quotesSnapshot.docs
            .map((doc) => Quote.fromMap(doc.data()))
            .toList();

        emit(TxQoutesStreamingData(quotes));
      },
      onError: (error) {
        emit(TxQoutesStreamError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// var quote = Quote.fromMap(state.quotes[index].data());
//             return QuoteListItem(quote: quote);
