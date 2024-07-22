import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key, required this.title});

  final String title;

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    debugPrint('build customer home');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('Customer Home'),
            Text('平均報價'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text('刊登'),
        onPressed: () {
          context.go('/create_post');
        },
      ),
    );
  }
}
