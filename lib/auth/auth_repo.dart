import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/widgets/email_register_form.dart';
import 'package:house/auth/widgets/email_verify_page.dart';
import 'package:house/auth/widgets/forget_password_page.dart';
import 'package:house/auth/widgets/sms_login_form.dart';
import 'usecases/auth_usecases.dart';
import 'widgets/sign_in_form.dart';

/// - [登录流程](file://./diagrams/login_form_flow.wsd)
/// - [注册流程 - 第一步](file://./diagrams/register_1_phone_flow.wsd)
/// - [注册流程 - 第二步](file://./diagrams/register_2_password_flow.wsd)

class AuthRepo {
  final AuthUsecases authUsecases;

  AuthRepo({required this.authUsecases});

  ///[UI]
  Widget buildLoginForm(BuildContext context) => SignInForm(
        authRepo: this,
        init: () {},
      );

  Widget buildSmsSignInForm() => SmsSignInForm(
        authUsecases: authUsecases,
      );

  Widget buildEmailRegisterForm() =>
      EmailRegisterForm(authUsecases: authUsecases);

  Widget buildEmailVerifyPage() => const EmailVerifyPage();

  Widget buildForgetPasswordPage() =>
      ForgetPasswordPage(authUsecases: authUsecases);
}
