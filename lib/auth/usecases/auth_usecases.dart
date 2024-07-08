import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:house/auth/usecases/register_usecsae.dart';
import 'package:house/auth/usecases/sign_in_usecases.dart';

class AuthUsecases {
  final FirebaseAuth _firebaseAuth;

  AuthUsecases({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  late final SignInUsecases signIn =
      SignInUsecases(firebaseAuth: _firebaseAuth);

  late final RegisterUsecases register = RegisterUsecases(auth: _firebaseAuth);

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
