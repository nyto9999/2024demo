import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house/firestore/model/transaction.dart';
import 'package:house/tx/bloc/master/qoute_stream/qoute_stream.dart';
import 'package:house/tx/bloc/shared/tx_stream/tx_stream.dart';
import 'package:house/tx/pages/master_page/add_quote_dialog.dart';

class MasterTxOpsPage extends StatelessWidget {
  final String txId;

  const MasterTxOpsPage({super.key, required this.txId});

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
          create: (context) => QouteStream()..qouteStream(txId),
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
                      // context.read<UserRoleCubit>().isMaster()
                      //     ? _masterQuotationButton(context, state.tx)
                      //     : Container()
                      _masterQuotationButton(context, state.tx),
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

  //stream tx by masterId
Widget _masterQuotationButton(BuildContext context, Tx tx) {
  return BlocBuilder<QouteStream, QouteStreamState>(
    builder: (context, state) {
      final quoteAmount = state is QouteStreamData ? state.qoute.quoteAmount.toString() : '尚未報價';
      final preQuote = state is QouteStreamData ? state.qoute.quoteAmount : null;

      return Column(
        children: [
          Text(quoteAmount),
          Row(
            children: _buildButtons(context, tx, preQuote),
          ),
        ],
      );
    },
  );
}

List<Widget> _buildButtons(BuildContext context, Tx tx, int? preQuote) {
  switch (tx.postStatus) {
    case 'paid':
      return [const Text('已付款')];
    case 'paying':
      return [
        ElevatedButton(
          child: const Text('客人正在付款...'),
          onPressed: () {},
        )
      ];
    case 'pending':
      return [
        ElevatedButton(
          child: const Text('修改報價'),
          onPressed: () {
            addQuotationDialog(
              preQuote: preQuote,
              context: context,
              txId: tx.id!,
              customerId: tx.customerId!,
            );
          },
        )
      ];
    default:
      return [const Text('未知')];
  }
}
}
