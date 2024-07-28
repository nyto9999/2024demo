import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:house/firestore/model/transaction.dart';
import 'package:house/helper/const.dart';

class CustomerPendingTxTile extends StatelessWidget {
  const CustomerPendingTxTile({super.key, required this.tx});
  final Tx tx;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('${tx.kind}'),
      title: Text('${tx.address}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 左對齊
        children: [
          Text('${tx.postDesc}'),
          Text('${tx.workDate}'),
        ],
      ),
      onTap: () {
        context.go('/${Const.my_tx}/${Const.c_tx_ops}/?id=${tx.id}');
      },
    );
  }
}
