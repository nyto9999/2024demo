import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/usecases/auth_usecases.dart';

class EmailRegisterForm extends StatefulWidget {
  const EmailRegisterForm({
    super.key,
    required this.authUsecases,
  });
  final AuthUsecases authUsecases;

  @override
  State<EmailRegisterForm> createState() => _EmailRegisterFormState();
}

class _EmailRegisterFormState extends State<EmailRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App帳號註冊'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: '密碼'),
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(labelText: '確認密碼'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final credential = await widget.authUsecases.register
                          .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      await credential.user?.sendEmailVerification();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.go('/register/email_verify',
                            extra: _emailController.text);
                      });
                    } catch (e) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$e'),
                          ),
                        );
                      });
                    }
                  },
                  child: const Text('註冊'),
                ),
              ],
            )),
      ),
    );
  }
}
