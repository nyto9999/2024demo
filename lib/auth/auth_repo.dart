import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:house/auth/methods/auth/auth_platform.dart';
import 'package:house/auth/widgets/sigin_up_page.dart';
import 'package:house/auth/widgets/email_verify_page.dart';
import 'package:house/auth/widgets/forget_password_page.dart';
import 'package:house/auth/widgets/sms_sign_in_form.dart';
import 'package:house/firestore/model/user_role.dart';
import 'package:house/main.dart';
import 'package:house/router/router.dart';
import 'widgets/sign_in_page.dart';

class AuthRepo {
  final AuthPlatform authMethods;
  AuthRepo({required this.authMethods});

  Stream<UserRoleModel?> userRoleStream() {
    return firestoreRepo.userRoleStream();
  }

  Future<void> updateUserRole(String newRole) async {
    await firestoreRepo.updateUserRole(auth.currentUser?.uid, newRole);
  }

  ///[UI]
  Widget buildLoginForm(BuildContext context) => SignInPage(
        authRepo: this,
        init: () {
          routerConfigNotifier.updateRoleAndConfig();
        },
      );

  //send
  Widget buildSmsSignInForm() => SmsSignInForm(
        auth: authMethods,
      );

  Widget buildEmailRegisterForm() => SignUpPage(auth: authMethods);

  Widget buildEmailVerifyPage() => const EmailVerifyPage();

  Widget buildForgetPasswordPage() => ForgetPasswordPage(auth: authMethods);
}
