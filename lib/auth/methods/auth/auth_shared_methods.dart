import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/helper/firebase_auth_error_translator.dart';

import 'package:house/main.dart';
import 'package:house/router/initial_routing/initial_routing_config.dart';
import 'package:house/router/router.dart';

mixin AuthSharedMethods {
  Future<void> forgetPassword(String email) async {
    return await handleAuthErrors(() async {
      await auth.sendPasswordResetEmail(email: email);
    });
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async =>
      await handleAuthErrors(() async {
        final credential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return credential;
      });

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await handleAuthErrors(() async {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    });
  }

  Future<void> signOut(BuildContext context) async {
    await auth.signOut();
 
    routerConfigNotifier.value = initialRoutingConfig();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.go('/sign_in');
    // });
  }
}
