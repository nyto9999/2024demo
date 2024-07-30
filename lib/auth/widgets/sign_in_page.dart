import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/auth_repo.dart';
import 'package:house/auth/bloc/email_sign_in/email_sign_in_cubit.dart';
import 'package:house/auth/bloc/google_sign_in/google_sign_in_cubit.dart';
import 'package:house/helper/auth_validator.dart';
import 'package:house/helper/custom_style.dart';
import 'package:house/auth/methods/loacl_auth/local_auth_methods.dart';
import 'package:house/main.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
    required this.authRepo,
    required this.init,
  });

  final AuthRepo authRepo;
  final Function init;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.init();

      analytics.logAppOpen();
      analytics.logScreenView(screenName: '/登入畫面');
    });
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _bioSignInButton() {
    return context.read<LocalAuthMethods>().isAvailable
        ? SignInButtonBuilder(
            backgroundColor: Colors.green,
            onPressed: () async {},
            text: 'faceid')
        : Container();
  }

  Widget _googleSignInButton() {
    return BlocProvider(
      create: (context) => GoogleSignInCubit(widget.authRepo.authMethods),
      child: BlocConsumer<GoogleSignInCubit, GoogleSignInState>(
        listener: (context, state) {
          switch (state) {
            case GoogleSignInSuccess():
              context.go('/');
            case GoogleSignInFailure():
            
              setState(() => _errorMessage = state.error);
            default:
          }
        },
        builder: (context, state) {
          return SignInButton(
            padding: EdgeInsets.only(
              top: 6.5.h,
              bottom: 6.5.h,
            ),
            Buttons.googleDark,
            text: 'Google',
            onPressed: () {
              state is GoogleSignInLoading
                  ? null
                  : context.read<GoogleSignInCubit>().signInWithGoogle();
            },
          );
        },
      ),
    );
  }

  Widget _facebookSignInButton() {
    return SignInButton(
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 10.h,
      ),
      Buttons.facebook,
      text: 'Facebook',
      onPressed: () async {
        await widget.authRepo.authMethods.signInWithFacebook();
      },
    );
  }

  TextFormField _emailTextfield() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: '電子郵箱',
        hintText: '請輸入電子郵箱',
        border: OutlineInputBorder(),
      ),
      controller: _emailController,
      validator: Validator.email,
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
      validator: Validator.password,
    );
  }

  SignInButtonBuilder _smsCodeSignInButton() {
    return SignInButtonBuilder(
      padding: Custom.pad,
      text: '手機登入',
      icon: Icons.sms_rounded,
      onPressed: () {
        context.go('/sign_in/sms');
      },
      backgroundColor: Colors.blueGrey.shade700,
    );
  }

  ElevatedButton _forgetPasswordButton(BuildContext context) {
    return Custom.defaultButton(
      child: const Text(
        '忘記密碼',
      ),
      onPressed: () {
        context.push('/forget_password');
      },
    );
  }

  Widget _errorText() {
    return Text(
      _errorMessage ?? '',
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _emailSignInButton(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailSignInCubit(widget.authRepo.authMethods),
      child: BlocConsumer<EmailSignInCubit, EmailSignInState>(
        listener: (context, state) {
          switch (state) {
            case EmailSignInSuccess():
              context.go('/');
            case EmailNotVerified():
              context.go('/sign_up/email_verify', extra: _emailController.text);
            case EmailSignInFailure():
              setState(() => _errorMessage = state.error);
            default:
          }
        },
        builder: (context, state) {
          return Custom.defaultButton(
            child: state is EmailSignInLoading
                ? Custom.spinner(context)
                : const Text('會員登入'),
            onPressed: () async {
              state is EmailSignInLoading
                  ? null
                  : context.read<EmailSignInCubit>().signInWithEmailAndPassword(
                        formKey: _formKey,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
            },
          );
        },
      ),
    );
  }

  SignInButton _emailSignUpButton(BuildContext context) {
    return SignInButton(
      padding: Custom.pad,
      Buttons.email,
      text: '會員註冊',
      onPressed: () {
        context.push('/sign_up');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登入'),
      ),
      body: SingleChildScrollView(
        padding: Custom.padding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _emailTextfield(),
              Custom.gap,
              _passwordTextfield(),
              Custom.gap,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _forgetPasswordButton(context),
                  _emailSignInButton(context),
                ],
              ),
              Custom.gap,
              Custom.gap,
              Custom.divider('會員'),
              _emailSignUpButton(context),
              Custom.gap,
              _smsCodeSignInButton(),
              Custom.gap,
              Custom.divider('第三方登入'),
              _facebookSignInButton(),
              Custom.gap,
              _googleSignInButton(),
              Custom.gap,
              _bioSignInButton(),
              Custom.gap,
              _errorText(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
