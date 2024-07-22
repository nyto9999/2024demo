import 'package:flutter/material.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/main.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({
    super.key,
    this.quote,
  });

  final QuoteModel? quote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Column(
        children: [
          Text('id: ${quote?.id}'),
          Text('postId: ${quote?.postId}'),
          Text('masterId: ${quote?.masterId}'),
          Text('createdAt: ${quote?.createdAt}'),
          Text('updatedAt: ${quote?.updatedAt}'),
          Text('Quote: ${quote?.quoteAmount}'),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Line Pay'),
            onPressed: () {},
          ),
          ElevatedButton(
            child: const Text('第三方支付'),
            onPressed: () async {
              //模擬10秒進入第三方支付
              await firestoreRepo.updatePostStatus(
                  postId: quote!.postId!, status: 'paying');

              //模擬支付成功 post status paid

              // add order
              await firestoreRepo.addOrder(quote: quote!);
            },
          )
        ],
      ),
    );
  }
}
