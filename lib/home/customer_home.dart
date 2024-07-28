import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/fcm_service.dart';
import 'package:house/helper/const.dart';
import 'package:house/main.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key, required this.title});

  final String title;

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  void initState() {
    FcmService().initialize();

    super.initState();
  }

 

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
          // context.go('/${Const.c_add_tx}');

          FcmService().sendPushMessage();
        },
      ),
    );
  }
}
