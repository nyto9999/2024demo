import 'package:flutter/material.dart';

class ReviewDialog extends StatefulWidget {
  final Function(int rating, String review) onSubmit;

  const ReviewDialog({required this.onSubmit, super.key});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('撰寫評價'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          TextField(
            controller: _reviewController,
            decoration: const InputDecoration(
              labelText: '撰寫您的評價',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_rating > 0 && _reviewController.text.isNotEmpty) {
              widget.onSubmit(_rating, _reviewController.text);
              Navigator.of(context).pop();
            } else {
              // 提示用戶評分和評價不能為空
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('請填寫評分和評價')),
              );
            }
          },
          child: const Text('送出'),
        ),
      ],
    );
  }
}

void showReviewDialog(
    BuildContext context, Function(int rating, String review) onSubmit) {
  showDialog(
    context: context,
    builder: (context) => ReviewDialog(onSubmit: onSubmit),
  );
}
