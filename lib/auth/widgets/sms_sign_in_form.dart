import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/bloc/SmsSignIn/sms_sign_in_cubit.dart';
import 'package:house/auth/helper/auth_validator.dart';
import 'package:house/auth/helper/custom_style.dart';
import '../usecases/auth_usecases/auth_usecases.dart';

class SmsSignInForm extends StatefulWidget {
  const SmsSignInForm({
    super.key,
    required this.authUsecases,
  });

  final AuthUsecases authUsecases;

  @override
  State<SmsSignInForm> createState() => _SmsSignInFormState();
}

class _SmsSignInFormState extends State<SmsSignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final ValueNotifier<Widget> _smsCodeTextField = ValueNotifier(Container());

  Widget _goHomeOrSendSmsCodeButton() {
    return BlocProvider(
      create: (context) => SmsSignInCubit(widget.authUsecases),
      child: BlocConsumer<SmsSignInCubit, SmsSignInState>(
        listener: (context, state) {
          switch (state) {
            case SmsSignInCodeSent():
              _smsCodeTextField.value = TextFormField(
                controller: _smsCodeController,
                decoration: const InputDecoration(
                  hintText: '請輸入驗證碼',
                  labelText: '手機驗證碼(${kIsWeb ? 'WEB' : 'NATIVE'})',
                ),
              );
            case SmsSignInConfirmationSent():
              EasyLoading.show(status: '驗證中...');

            case SmsSignInSuccess():
              EasyLoading.dismiss();
              context.go('/');

            case SmsSignInFailure():
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
              ));
            default:
          }
        },
        builder: (context, state) {
          return Custom.mediumButton(
              onPressed: () {
                context.read<SmsSignInCubit>().sendSmsSignInCode(
                      sent: _smsCodeTextField.value is TextFormField,
                      smsCode: _smsCodeController.text,
                      formKey: _formKey,
                      phoneNo: _phoneController.text,
                    );
              },
              child: ValueListenableBuilder<Widget>(
                valueListenable: _smsCodeTextField,
                builder: (context, value, child) {
                  return Text(value is TextFormField ? '確認' : '發送手機驗證碼');
                },
              ));
        },
      ),
    );
  }

  ValueListenableBuilder<Widget> _shouldDisplaySmsTextfield() {
    return ValueListenableBuilder<Widget>(
        valueListenable: _smsCodeTextField,
        builder: (context, value, child) => value);
  }

  TextFormField _phoneTextfield() {
    return TextFormField(
      decoration: const InputDecoration(labelText: '手機號碼'),
      controller: _phoneController,
      validator: (value) => AuthValidator.phoneNo(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('簡訊登入'),
      ),
      body: Padding(
        padding: Custom.pad,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _phoneTextfield(),
              const SizedBox(height: 20),
              _shouldDisplaySmsTextfield(),
              _goHomeOrSendSmsCodeButton(),
            ],
          ),
        ),
      ),
    );
  }
}
