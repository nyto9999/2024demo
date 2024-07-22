import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:house/firestore/exception/post_exception.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/main.dart';
import 'package:house/post/post_repo.dart';

part 'master_add_post_quote_state.dart';

class MasterAddPostQuoteCubit extends Cubit<MasterAddPostQuoteState> {
  final PostRepo postRepo;

  MasterAddPostQuoteCubit(this.postRepo) : super(MasterAddPostQuoteInitial());

  Future<void> addQuote({
    required String postId,
    required String? postOwnerId,
    required String quoteAmountStr,
  }) async {
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      emit(const MasterAddPostQuoteError('登入異常，請重新登入'));
      return;
    }

    final quoteAmount = int.tryParse(quoteAmountStr);
    if (quoteAmount == null) {
      emit(const MasterAddPostQuoteError('報價金額必須是數字'));
      return;
    }

    if (uid == postOwnerId) {
      emit(const MasterAddPostQuoteError('不能對自己的貼文報價'));
      return;
    }

    try {
      emit(MasterAddPostQuoteLoading());
      final QuoteModel quote = QuoteModel(
        postId: postId,
        masterId: uid,
        quoteAmount: quoteAmount,
      );
      //function
      await firestoreRepo.addQuote(quote: quote);
      
      emit(MasterAddPostQuoteSuccess());
    } on PostStatusException catch (e) {
      debugPrint('here');
      EasyLoading.showError(e.message);
    } catch (e) {
      emit(MasterAddPostQuoteError(e.toString()));
    }
  }
}
