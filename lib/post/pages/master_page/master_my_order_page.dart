import 'package:flutter/material.dart';

class MasterMyOrderPage extends StatelessWidget {
  const MasterMyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build master my order');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Master My Order'),
      ),
      body: const Center(
        child: Text('Master My Order'),
      ),
    );
  }
}
