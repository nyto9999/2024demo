import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house/firestore/model/transaction.dart';
import 'package:house/tx/bloc/customer/my_txs_paginate/my_txs_paginate.dart';
import 'package:house/tx/pages/customer_page/customer_my_tx_page/widgets/c_done_txs_tile.dart';
import 'package:house/tx/pages/customer_page/customer_my_tx_page/widgets/c_paid_txs_tile.dart';
import 'package:house/tx/pages/customer_page/customer_my_tx_page/widgets/c_pending_txs_tile.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: '張貼中'),
  Tab(text: '已付款'),
  Tab(text: '已結案'),

];

class CustomerMyTxsPage extends StatelessWidget {
  const CustomerMyTxsPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('CustomerMyTxsPage build');

    return DefaultTabController(
      length: tabs.length,

      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            debugPrint('tabController.index ${tabController.index}');
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Text('My Transactions'),
              ],
            ),
            bottom: const TabBar(tabs: tabs),
          ),
          body: TabBarView(
            children: tabs.map((Tab tab) {
              return BlocProvider(
                  create: (context) =>
                      CustomerMyTxsPaginate()..paginateBy(tab.text),
                  child: _customerPosts(tab.text));
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _customerPosts(String? tabText) {
    return BlocBuilder<CustomerMyTxsPaginate, CustomerMyTxsPaginateState>(
      builder: (context, state) {
        final cubit = context.read<CustomerMyTxsPaginate>();

        return cubit.pagination.streamBuilder(
          (context, snapshot) {
            final txs = snapshot.data;

            if (txs == null || txs.isEmpty) {
              return const Center(child: Text('暫時沒有貼文'));
            }

            return ListView.builder(
              controller: cubit.pagination.scrollController,
              itemCount: txs.length,
              itemBuilder: (context, index) {
                final transaction =
                    Tx.fromMap(txs[index].data() as Map<String, dynamic>);
                return switch (tabText) {
                  '張貼中' => CustomerPendingTxTile(tx: transaction),
                  '已付款' => CustomerPaidTxTile(tx: transaction),
                  '已結案' => CustomerDoneTxTile(tx: transaction),
                  _ => const SizedBox.shrink(),
                };
              },
            );
          },
        );
      },
    );
  }
}
