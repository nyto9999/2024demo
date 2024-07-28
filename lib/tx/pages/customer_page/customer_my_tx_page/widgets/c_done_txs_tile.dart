import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:house/firestore/model/transaction.dart';
import 'package:house/helper/const.dart';
import 'package:house/main.dart';
import 'package:house/tx/pages/customer_page/customer_my_tx_page/widgets/c_review_dialog.dart';

class CustomerDoneTxTile extends StatelessWidget {
  CustomerDoneTxTile({super.key, required this.tx});
  final Tx tx;

  late final ValueNotifier<bool> reviewed =
      ValueNotifier((tx.reviewed ?? false));

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
        valueListenable: reviewed,
        builder: (context, value, child) {
          return ElevatedButton(
            onPressed: value
                ? null
                : () async {
                    showReviewDialog(context, (rating, review) async {
                      await firestoreRepo.updateTxReviewed(
                          transactionId: tx.id!);
                      await firestoreRepo.addReview(
                        masterId: tx.masterId!,
                        transactionId: tx.id!,
                        rating: rating,
                        review: review,
                      );

                      await firestoreRepo.updateMasterRating(
                        masterId: tx.masterId!,
                        rating: rating,
                      );

                      reviewed.value = true;
                    });
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
            child: Text(value ? '已結案' : '評價'),
          );
        },
      ),
      onTap: () {
        context.go('/${Const.my_tx}/${Const.c_tx_ops}/?id=${tx.id}');
      },
    );
  }
}
