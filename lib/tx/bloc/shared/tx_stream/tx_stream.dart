import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:house/firestore/firestore_repo.dart';
import 'package:house/firestore/model/transaction.dart';
import 'package:house/main.dart';
import 'dart:async';

part 'tx_stream_state.dart';
// master , customer

class TxStream extends Cubit<TxStreamState> {
  final FireStoreRepo repo;
  final String id;
  StreamSubscription<Tx>? _sub;
  Tx tx = Tx.empty();

  TxStream({required this.id})
      : repo = firestoreRepo,
        super(TxStreamInitial());

  void streamTx(String id) {
    emit(TxStreamLoading());

    // function
    _sub = repo.streamTransaction(id).listen((event) {
      tx = event;

      emit(TxEvent(tx));
    }, onError: (e) {
      emit(TxStreamError(e.toString()));
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
