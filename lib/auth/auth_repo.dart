import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';
import 'package:house/auth/usecases/loacl_auth_usecases/local_auth_usecases.dart';
import 'package:house/auth/widgets/sigin_up_page.dart';
import 'package:house/auth/widgets/email_verify_page.dart';
import 'package:house/auth/widgets/forget_password_page.dart';
import 'package:house/auth/widgets/sms_sign_in_form.dart';

import 'widgets/sign_in_page.dart';

class AuthRepo {
  AuthRepo({
    required this.authUsecases,
    required this.localAuthUsecases,
  });

  final AuthUsecases authUsecases;
  final LocalAuthUsecases localAuthUsecases;

  ///[UI]
  Widget buildLoginForm(BuildContext context) => SignInPage(
        authRepo: this,
        init: () {},
      );

  Widget buildSmsSignInForm() => SmsSignInForm(
        authUsecases: authUsecases,
      );

  Widget buildEmailRegisterForm() => SignUpPage(authUsecases: authUsecases);

  Widget buildEmailVerifyPage() => const EmailVerifyPage();

  Widget buildForgetPasswordPage() =>
      ForgetPasswordPage(authUsecases: authUsecases);
}
