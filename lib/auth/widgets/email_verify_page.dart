import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailVerifyPage extends StatefulWidget {
  const EmailVerifyPage({super.key});

  @override
  State<EmailVerifyPage> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verify ${GoRouterState.of(context).extra}'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('信箱驗證中，請至信箱確認'),
          ),
         
          ElevatedButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('回登入頁面'))
        ],
      ),
    );
  }
}
