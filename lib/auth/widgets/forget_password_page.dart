import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/usecases/auth_usecases.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key, required this.authUsecases});

  final AuthUsecases authUsecases;

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();

  TextField _emailTextfield() {
    return TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: '電子郵箱'),
        );
  }

  ElevatedButton _returnLoginPage(BuildContext context) {
    return ElevatedButton(
          onPressed: () {
            context.go('/login');
          },
          child: const Text('返回登入'),
        );
  }

  ElevatedButton _sendVerifyEmailButton(
      BuildContext context, ValueNotifier<bool> sendEmail) {
    return ElevatedButton(
      onPressed: () {
        try {
          widget.authUsecases.signIn.forgetPassword(_emailController.text);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: sendEmail,
        builder: (context, value, child) {
          return Text(value ? '重新發送驗證郵件' : '發送驗證郵件');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> sendEmail = ValueNotifier(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('忘記密碼'),
      ),
      body: Column(
        children: [
          const Text('請輸入您的電子郵箱 以重設密碼'),
          _emailTextfield(),
          _sendVerifyEmailButton(context, sendEmail),
          _returnLoginPage(context)
        ],
      ),
    );
  }
}
