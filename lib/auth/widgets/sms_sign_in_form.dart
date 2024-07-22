import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:house/auth/bloc/sms_sign_in/sms_sign_in_cubit.dart';
import 'package:house/auth/helper/auth_validator.dart';
import 'package:house/auth/helper/custom_style.dart';
import 'package:house/auth/methods/auth/auth_platform.dart';
import 'package:house/auth/widgets/sms_confirm_form.dart';

class SmsSignInForm extends StatefulWidget {
  const SmsSignInForm({
    super.key,
    required this.auth,
  });

  final AuthPlatform auth;

  @override
  State<SmsSignInForm> createState() => _SmsSignInFormState();
}

class _SmsSignInFormState extends State<SmsSignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  final ValueNotifier<Widget> _smsCodeTextField = ValueNotifier(Container());
  @override
  void dispose() {
    _phoneController.dispose();
    _smsCodeTextField.dispose();
    super.dispose();
  }

  Widget _sendOrConfirmSmsCode() {
    return BlocProvider(
      create: (context) => SmsSignInCubit(widget.auth),
      child: BlocConsumer<SmsSignInCubit, SmsSignInState>(
        listener: (context, state) {
          switch (state) {
            case SmsSignInCodeSent():
              _goSmsConfirmPage(context, state);

            case SmsSignInConfirmationSent():
              EasyLoading.show(status: '驗證中...');
            case SmsSignInFailure():
              EasyLoading.dismiss();
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
                      formKey: _formKey,
                      phoneNo: _phoneController.text,
                    );
              },
              child: ValueListenableBuilder<Widget>(
                valueListenable: _smsCodeTextField,
                builder: (context, value, child) {
                  return const Text('發送手機驗證碼');
                },
              ));
        },
      ),
    );
  }

  Future<dynamic> _goSmsConfirmPage(
      BuildContext context, SmsSignInCodeSent state) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SmsConfirmPage(
                confirmationResultOrVerificationId: state.result,
                phoneNo: _phoneController.text,
              )),
    );
  }

  ValueListenableBuilder<Widget> _shouldDisplaySmsTextfield() {
    return ValueListenableBuilder<Widget>(
        valueListenable: _smsCodeTextField,
        builder: (context, value, child) => value);
  }

  TextFormField _phoneTextfield() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: '手機號碼',
        border: OutlineInputBorder(),
      ),
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
              _sendOrConfirmSmsCode(),
            ],
          ),
        ),
      ),
    );
  }
}
