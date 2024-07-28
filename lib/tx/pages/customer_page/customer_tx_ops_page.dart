import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house/firestore/model/transaction.dart';
import 'package:house/helper/custom_style.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/main.dart';
import 'package:house/tx/bloc/customer/tx_qoutes_stream/tx_qoutes_stream.dart';
import 'package:house/tx/bloc/shared/tx_stream/tx_stream.dart';

class CustomerTxOpsPage extends StatelessWidget {
  final String txId;

  const CustomerTxOpsPage({super.key, required this.txId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TxStream(
            id: txId,
          )..streamTx(txId),
        ),
        BlocProvider(
          create: (context) => TxQoutesStream()..streamTransactionQuotes(txId),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Transaction id: $txId'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<TxStream, TxStreamState>(
            builder: (context, state) {
              return switch (state) {
                TxStreamLoading() =>
                  const Center(child: CircularProgressIndicator()),
                TxEvent() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Title: ${state.tx.postDesc ?? 'No title'}'),
                      Text('Kind: ${state.tx.kind ?? 'No kind'}'),
                      Text('Address ${state.tx.address ?? 'No address'}'),
                      Text('Name'
                          '${state.tx.customerName ?? 'No name'}'),
                      Text('Status : '
                          '${state.tx.workStatus ?? 'No status'}'),
                      Text('工作日 :'
                          '${state.tx.workDate ?? 'No working day'}'),
                      Text('Owner : : ${state.tx.customerId ?? 'No owner'}'),
                      Text(
                          'Created At: ${state.tx.createdAt?.toString() ?? 'No date'}'),
                      Text('Post Status: ${state.tx.postStatus}'),
                      state.tx.postStatus == 'paid'
                          ? const Text('已付款')
                          : _customerQuotationListView(state.tx),
                      // _customerQuotationListView(state.tx),
                    ],
                  ),
                TxStreamError() =>
                  Center(child: Text('Error: ${state.message}')),
                _ => const SizedBox.shrink(),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _customerQuotationListView(Tx tx) {
    return BlocBuilder<TxQoutesStream, TxQoutesStreamState>(
      builder: (context, state) {
        return switch (state) {
          TxQoutesStreamingData() => ListView.builder(
              shrinkWrap: true,
              itemCount: state.quotes.length,
              itemBuilder: (context, index) {
                final qoute = state.quotes[index];
                return QuoteListItem(
                  quote: qoute,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext c) {
                        return AlertDialog(
                          title: const Text('选择支付方式'),
                          content: const Text('请选择支付方式'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Line Pay'),
                              onPressed: () {
                                Navigator.of(c).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('银行支付'),
                              onPressed: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) async {
                                  await firestoreRepo.updateTxAfterPayment(
                                      tx: tx.copyWith(
                                    postStatus: 'paid',
                                    workStatus: 'undone',
                                    masterId: qoute.masterId,
                                    masterName: qoute.masterName,
                                    confirmedQuote: qoute,
                                  ));

                                  debugPrint('tx: ${tx.toString()}');
                                });
                                Navigator.of(c).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          TxQoutesStreamError() =>
            Center(child: Text('Error: ${state.message}')),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class QuoteListItem extends StatefulWidget {
  final Quote quote;
  final Function() onPressed;

  const QuoteListItem(
      {super.key, required this.quote, required this.onPressed});

  @override
  _QuoteListItemState createState() => _QuoteListItemState();
}

class _QuoteListItemState extends State<QuoteListItem> {
  bool _isUpdated = false;
  String? _previousQuoteAmount;

  @override
  void didUpdateWidget(covariant QuoteListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quote.quoteAmount != widget.quote.quoteAmount) {
      setState(() {
        _isUpdated = true;
        _previousQuoteAmount = oldWidget.quote.quoteAmount.toString();
      });
    } else {
      setState(() {
        _isUpdated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(
            'Quote: ${widget.quote.quoteAmount}',
            style: TextStyle(color: _isUpdated ? Colors.red : Colors.black),
          ),
          if (_isUpdated && _previousQuoteAmount != null)
            Text(
              ' (師傅剛剛更新了價格原價格$_previousQuoteAmount)',
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Master ID: ${widget.quote.masterId}'),
          Text('Created At: ${widget.quote.createdAt}'),
          Text('Updated At: ${widget.quote.updatedAt}'),
        ],
      ),
      trailing: Custom.defaultButton(
        child: const Text('接受'),
        onPressed: widget.onPressed,
      ),
    );
  }
}
