import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:house/post/bloc/master_add_post_quote/master_add_post_quote_cubit.dart';
import 'package:house/post/post_repo.dart';

void addQuotationDialog({
  required BuildContext context,
  required String? postOwnerId,
  required String postId,
}) {
  TextEditingController quoteController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => MasterAddPostQuoteCubit(
          context.read<PostRepo>(),
        ),
        child: AlertDialog(
          title: const Text('輸入報價'),
          content: TextField(
            controller: quoteController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '輸入金額',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocConsumer<MasterAddPostQuoteCubit, MasterAddPostQuoteState>(
              listener: (context, state) {
                switch (state) {
                  case MasterAddPostQuoteSuccess():
                    Navigator.of(context).pop();
                    EasyLoading.showSuccess('報價成功');

                  case MasterAddPostQuoteError():
                    Navigator.of(context).pop();
                    EasyLoading.showError(state.message);

                  default:
                }
              },
              builder: (context, state) {
                return TextButton(
                  child: const Text('確定'),
                  onPressed: () {
                    print('posid $postId');
                    context.read<MasterAddPostQuoteCubit>().addQuote(
                          postId: postId,
                          postOwnerId: postOwnerId,
                          quoteAmountStr: quoteController.text,
                        );
                  },
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
