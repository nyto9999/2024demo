import 'package:flutter/material.dart';

import 'package:house/firestore/model/transaction.dart';
import 'package:house/main.dart';

class TodayTxTile extends StatelessWidget {
  TodayTxTile({super.key, required this.tx, required this.tabController});

  final Tx tx;
  final TabController tabController;

  late final ValueNotifier<bool> isDone =
      ValueNotifier(tx.workStatus == 'done');

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
        builder: (context, value, child) {
          return ElevatedButton(
            onPressed: value
                ? null // 如果 isDone 為 true，禁用按鈕
                : () async {
                    await firestoreRepo.updateTxWorkStatus(
                        transactionId: tx.id!, status: 'done');
                    isDone.value = true;
                    tabController.animateTo(2);
                  },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.greenAccent; // 禁用時的背景色
                  }
                  return null; // 使用默認顏色
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.black; // 禁用時的文字顏色
                  }
                  return null; // 使用默認顏色
                },
              ),
            ),
            child: Text(value ? '已完成' : '確認工作完成'),
          );
        },
      ),
      onTap: () {},
    );
  }
}
