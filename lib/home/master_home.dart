import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/firestore/model/transaction.dart';
import 'package:house/helper/const.dart';
import 'package:house/tx/bloc/master/txs_paginate/txs_paginate.dart';

class MasterHomePage extends StatelessWidget {
  const MasterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build master home');
    return Scaffold(
      appBar: AppBar(
        title: const Text('師傅首頁'),
      ),
      body: BlocProvider(
        create: (context) => TxsPaginate(),
        child: _getPostsExcludingMasterSelf(context),
      ),
    );
  }

  Widget _getPostsExcludingMasterSelf(BuildContext context) {
    return BlocBuilder<TxsPaginate, TxsPaginateState>(
      builder: (context, state) {
        final cubit = context.read<TxsPaginate>();

        return cubit.pagination.streamBuilder(
          (context, snapshot) {
            final txs = snapshot.data;

            if (txs == null || txs.isEmpty) {
              return const Center(child: Text('暫時沒有貼文'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await cubit.refreshTransactions();
              },
              child: ListView.builder(
                controller: cubit.pagination.scrollController,
                itemCount: txs.length,
                itemBuilder: (context, index) {
                  final tx =
                      Tx.fromMap(txs[index].data() as Map<String, dynamic>);
                  return ListTile(
                    title: Text(tx.toString()),
                    onTap: () {
                      context.go('/${Const.m_tx_ops}/?id=${txs[index].id}');
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
