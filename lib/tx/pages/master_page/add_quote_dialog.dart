import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:house/helper/auth_validator.dart';
import 'package:house/tx/bloc/master/add_tx_quote_pressed/add_tx_quote_pressed.dart';

void addQuotationDialog({
  required int? preQuote,
  required BuildContext context,
  required String customerId,
  required String txId,
}) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController quoteController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (context) => AddTxQuotePressed(),
        child: AlertDialog(
          title: const Text('輸入報價'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: quoteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '輸入金額',
              ),
              validator: (nextQoute) =>
                  Validator.quoteAmount(nextQoute, preQuote),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocConsumer<AddTxQuotePressed, AddTxQuotePressedState>(
              listener: (context, state) {
                if (state is AddTxQuotePressedSuccess) {
                  Navigator.of(context).pop();
                  EasyLoading.showSuccess('報價成功');
                } else if (state is AddTxQuotePressedError) {
                  Navigator.of(context).pop();
                  EasyLoading.showError(state.message);
                }
              },
              builder: (context, state) {
                return TextButton(
                  child: const Text('確定'),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      context.read<AddTxQuotePressed>().addQuote(
                            txId: txId,
                            customerId: customerId,
                            quoteAmount: int.parse(quoteController.text),
                          );
                    }
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
