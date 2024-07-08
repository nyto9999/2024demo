// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/auth_repo.dart';

//登入頁面
class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
    required this.authRepo,
    required this.init,
  });

  final AuthRepo authRepo;
  final Function init;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.init();
    });
  }

  List<Widget> _textFields() {
    return [
      _emailTextfield(),
      _passwordTextfield(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _forgetPasswordButton(),
          _smsCodeLoginButton(),
        ],
      ),
      _emailLoginButton(context),
      const Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _facebookLoginButton(),
          _googleLoginButton(),
        ],
      )
    ];
  }

  ElevatedButton _googleLoginButton() {
    return ElevatedButton(
          child: const Text('Google登入'),
          onPressed: () async {
            try {
              await widget.authRepo.authUsecases.signIn.signInWithGoogle();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/');
              });
            } catch (e) {
              setState(() {
                _errorMessage = '$e';
              });
            }
          },
        );
  }

  ElevatedButton _facebookLoginButton() {
    return ElevatedButton(
      child: const Text('Facebook登入'),
      onPressed: () async {
        try {
          await widget.authRepo.authUsecases.signIn.siginInWithFacebook();
        } catch (e) {
          setState(() {
            _errorMessage = '$e';
          });
        }
      },
    );
  }

  TextField _emailTextfield() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: '電子郵箱'),
    );
  }

  TextField _passwordTextfield() {
    return TextField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: '密碼'),
      obscureText: true,
    );
  }

  ElevatedButton _smsCodeLoginButton() {
    return ElevatedButton(
      child: const Text('使用簡訊登入'),
      onPressed: () {
        context.go('/login/sms');
      },
    );
  }

  ElevatedButton _forgetPasswordButton() {
    return ElevatedButton(
      child: const Text('忘記密碼'),
      onPressed: () {
        context.go('/register/forget_password');
      },
    );
  }

  Widget _errorText() {
    return Text(
      _errorMessage ?? '',
      style: const TextStyle(color: Colors.red),
    );
  }

  ElevatedButton _emailLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final credential = await widget.authRepo.authUsecases.signIn
              .signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          if (credential.user?.emailVerified ?? false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/');
            });
          } else {
            await credential.user?.sendEmailVerification();
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              context.go('/register/email_verify',
                  extra: _emailController.text);
            });
          }
        } catch (e) {
          setState(() {
            _errorMessage = '$e';
          });
        }
      },
      child: const Text('登入'),
    );
  }

  TextButton _emailRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go('/register');
      },
      child: const Text('註冊'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._textFields(),
            _errorText(),
            const SizedBox(height: 20),
            _emailRegisterButton(context),
            ElevatedButton(
                onPressed: () {
                  print('${widget.authRepo.authUsecases.currentUser}');
                },
                child: const Text('user'))
          ],
        ),
      ),
    );
  }
}
