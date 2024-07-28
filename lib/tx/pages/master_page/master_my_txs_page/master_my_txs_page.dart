import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house/firestore/model/transaction.dart';
import 'package:house/tx/bloc/master/my_tx_paginate/master_my_txs_paginate.dart';
import 'package:house/tx/pages/master_page/master_my_txs_page/widgets/incoming_tx_tile.dart';
import 'package:house/tx/pages/master_page/master_my_txs_page/widgets/today_tx_tile.dart';
import 'package:house/tx/pages/master_page/master_my_txs_page/widgets/m_done_tx_tile.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: '工作清單'),
  Tab(text: '今天工作'),
  Tab(text: '已完成'),
];

class MasterMyTxsPage extends StatelessWidget {
  const MasterMyTxsPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build master my order');

    return DefaultTabController(
      length: tabs.length,
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
                Text('My Orders'),
              ],
            ),
            bottom: const TabBar(tabs: tabs),
          ),
          body: TabBarView(
            children: tabs.map((Tab tab) {
              return BlocProvider(
                create: (context) =>
                    MasterMyTxsPaginate()..paginateBy(tab.text),
                child: _masterOrders(tab.text, tabController),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _masterOrders(String? tabText, TabController tabController) {
    return BlocBuilder<MasterMyTxsPaginate, MasterMyTxsPaginateState>(
      builder: (context, state) {
        final cubit = context.read<MasterMyTxsPaginate>();

        return cubit.pagination.streamBuilder(
          (context, snapshot) {
            final orders = snapshot.data;

            if (orders == null || orders.isEmpty) {
              return const Center(child: Text('暫時沒有訂單'));
            }

            return ListView.builder(
              controller: cubit.pagination.scrollController,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final transaction =
                    Tx.fromMap(orders[index].data() as Map<String, dynamic>);

                return switch (tabText) {
                  '工作清單' => IncomingTxTile(tx: transaction),
                  '今天工作' => TodayTxTile(
                      tx: transaction,
                      tabController: tabController,
                    ),
                  '已完成' => MasterTxDoneTile(
                      tx: transaction,
                      tabController: tabController,
                    ),
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
