import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/bloc/emailSignUp/email_sign_up_cubit.dart';
import 'package:house/auth/helper/auth_validator.dart';
import 'package:house/auth/helper/custom_style.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    required this.authUsecases,
  });

  final AuthUsecases authUsecases;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _registerButton() {
    return BlocProvider(
      create: (context) => EmailSignUpCubit(widget.authUsecases),
      child: BlocConsumer<EmailSignUpCubit, EmailSignUpState>(
        listener: (context, state) {
          switch (state) {
            case EmailSignUpSuccess():
              context.go('/sign_up/email_verify', extra: _emailController.text);

            case EmailSignUpFailure():
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
              break;
            default:
          }
        },
        builder: (context, state) {
          return state is EmailSignUpLoading
              ? Custom.spinner(context)
              : Custom.defaultButton(
                  child: const Text('註冊'),
                  onPressed: () {
                    state is EmailSignUpLoading
                        ? null
                        : context
                            .read<EmailSignUpCubit>()
                            .signUpWithEmailAndPassword(
                                formKey: _formKey,
                                email: _emailController.text,
                                password: _passwordController.text);
                  },
                );
        },
      ),
    );
  }

  TextFormField _confirmPassword() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: '密碼確認',
        border: OutlineInputBorder(),
        hintText: '請再次輸入密碼',
      ),
      controller: _confirmPasswordController,
      obscureText: true,
      validator: (value) =>
          AuthValidator.confirmPassword(_passwordController.text, value),
    );
  }

  TextFormField _passwordTextfield() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: '密碼',
        hintText: '請輸入密碼',
        border: OutlineInputBorder(),
      ),
      controller: _passwordController,
      obscureText: true,
      validator: (value) => AuthValidator.password(value),
    );
  }

  TextFormField _emailTextfield() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: '請輸入電子郵箱',
        labelText: '電子郵箱',
        border: OutlineInputBorder(),
      ),
      controller: _emailController,
      validator: (value) => AuthValidator.email(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App帳號註冊'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Custom.padding,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _emailTextfield(),
                  Custom.gap,
                  _passwordTextfield(),
                  Custom.gap,
                  _confirmPassword(),
                  Custom.gap,
                  _registerButton(),
                ],
              )),
        ),
      ),
    );
  }
}
