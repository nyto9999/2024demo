import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/bloc/forgetPassword/forget_password_cubit.dart';
import 'package:house/auth/helper/auth_validator.dart';
import 'package:house/auth/helper/custom_style.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key, required this.authUsecases});

  final AuthUsecases authUsecases;

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String message = '';

  TextFormField _emailTextfield() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: '電子郵箱',
        border: OutlineInputBorder(),
      ),
      controller: _emailController,
      validator: (value) => AuthValidator.email(value),
    );
  }

  ElevatedButton _returnLoginPage(BuildContext context) {
    return Custom.mediumButton(
        child: const Text(
          '返回登入頁面',
        ),
        onPressed: () {
          context.go('/sign_in');
        });
  }

  Widget _sendVerifyEmailButton(
      BuildContext context, ValueNotifier<bool> sendEmail) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(widget.authUsecases),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          switch (state) {
            case ForgetPasswordSuccess():
              setState(() => message = '驗證郵件已發送，請至信箱確認');

            case ForgetPasswordFailure():
              setState(() => message = state.error);
            default:
          }
        },
        builder: (context, state) {
          return Custom.mediumButton(
            child: ValueListenableBuilder<bool>(
              valueListenable: sendEmail,
              builder: (context, value, child) {
                return state is ForgetPasswordLoading
                    ? Custom.spinner(context)
                    : Text(
                        value ? '重新發送驗證郵件' : '發送驗證郵件',
                      );
              },
            ),
            onPressed: () {
              state is ForgetPasswordLoading
                  ? null
                  : context.read<ForgetPasswordCubit>().forgetPassword(
                        formKey: _formKey,
                        email: _emailController.text,
                      );
            },
          );
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
      body: Padding(
        padding: Custom.padding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _emailTextfield(),
              _ayncMessage(message),
              Custom.gap,
              _sendVerifyEmailButton(context, sendEmail),
              Custom.gap,
              _returnLoginPage(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _ayncMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize),
      ),
    );
  }
}
