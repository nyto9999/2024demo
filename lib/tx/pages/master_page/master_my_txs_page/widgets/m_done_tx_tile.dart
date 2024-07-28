import 'package:flutter/material.dart';
import 'package:house/firestore/model/transaction.dart';

//此widget 只有 workStatus == 'done'
class MasterTxDoneTile extends StatelessWidget {
  MasterTxDoneTile({super.key, required this.tx, required this.tabController});

  final Tx tx;
  final TabController tabController;

  //
  late final ValueNotifier<bool> isDone =
      ValueNotifier(tx.workStatus == 'done' && tx.reviewed == true);

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
      trailing: ValueListenableBuilder<bool>(
        valueListenable: isDone,
        builder: (context, isDoneValue, child) {
          return Text(isDoneValue ? '已結案' : '等待評價');
        },
      ),
      onTap: () {},
    );
  }
}
