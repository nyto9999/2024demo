import 'package:flutter/material.dart';

class CustomerNotificationPage extends StatelessWidget {
  const CustomerNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知'),
      ),
      body: const Center(
        child: Text('通知'),
      ),
    );
  }
}
