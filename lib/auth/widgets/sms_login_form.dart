import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../usecases/auth_usecases.dart';

class SmsSignInForm extends StatefulWidget {
  final AuthUsecases authUsecases;

  const SmsSignInForm({
    super.key,
    required this.authUsecases,
  });

  @override
  State<SmsSignInForm> createState() => _SmsSignInFormState();
}

class _SmsSignInFormState extends State<SmsSignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  final ValueNotifier<Widget> _smsCodeTextField = ValueNotifier(Container());
  ConfirmationResult? _confirmationResult;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: '手機號碼'),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<Widget>(
                  valueListenable: _smsCodeTextField,
                  builder: (context, value, child) => value),
              ElevatedButton(
                  onPressed: _onPressed,
                  child: ValueListenableBuilder<Widget>(
                    valueListenable: _smsCodeTextField,
                    builder: (context, value, child) {
                      return Text(value is TextFormField ? '下一步' : '驗證手機號碼');
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
    bool sent = _smsCodeTextField.value is TextFormField;

    // 前端驗證：如果還沒有發送簡訊驗證碼，檢查表單是否有效
    if (!sent && !_formKey.currentState!.validate()) {
      return;
    }

    try {
      switch ((sent, kIsWeb)) {
        case (false, true):
          // 如果還沒有發送簡訊驗證碼，且是在 Web 平台上，發送簡訊驗證碼
          await _sendSmsCodeWeb();
          break;
        case (false, false):
          // 如果還沒有發送簡訊驗證碼，且是在 Native 平台上，發送簡訊驗證碼
          await _sendSmsCodeNative();
          break;
        case (true, true):
          // 如果已經發送簡訊驗證碼，且是在 Web 平台上，確認簡訊驗證碼
          await _confirmSmsCodeWeb();
          break;
        case (true, false):
          // 如果已經發送簡訊驗證碼，且是在 Native 平台上，確認簡訊驗證碼
          await _confirmSmsCodeNative();
          break;
      }

      // 簡訊驗證碼發送和確認成功後，檢查當前用戶是否存在
      if (sent && widget.authUsecases.currentUser != null) {
        // 如果用戶存在，調用 onLoginSuccess 回調函數，導航到首頁或下一步
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/');
        });
      }
    } catch (e) {
      Future.microtask(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$e'),
        ));
      });
    }
  }

  Future<void> _sendSmsCodeWeb() async {
    _confirmationResult = await widget.authUsecases.register
        .signInWithPhoneNumberWeb(phoneNo: _phoneController.text);

    //如果還沒有發送簡訊驗證碼，顯示簡訊驗證碼輸入框
    _smsCodeTextField.value = TextFormField(
      controller: _smsCodeController,
      decoration: const InputDecoration(
          labelText: 'SMS 驗證碼(${kIsWeb ? 'WEB' : 'NATIVE'})'),
    );
  }

  Future<void> _sendSmsCodeNative() async {
    _verificationId = await widget.authUsecases.register
        .verifyPhoneNumberNative(phoneNo: _phoneController.text);
    //如果還沒有發送簡訊驗證碼，顯示簡訊驗證碼輸入框
    _smsCodeTextField.value = TextFormField(
      controller: _smsCodeController,
      decoration: const InputDecoration(
          labelText: 'SMS 驗證碼(${kIsWeb ? 'WEB' : 'NATIVE'})'),
    );
  }

  Future<void> _confirmSmsCodeWeb() async {
    await widget.authUsecases.register.confirmSmsCodeWeb(
      context: context,
      smsCode: _smsCodeController.text,
      confirmationResult: _confirmationResult,
    );
  }

  Future<void> _confirmSmsCodeNative() async {
    await widget.authUsecases.register.confirmSmsCodeNative(
      smsCode: _smsCodeController.text,
      verificationId: _verificationId!,
    );
  }
}
