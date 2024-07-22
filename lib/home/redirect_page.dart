import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/helper/custom_style.dart';
import 'package:house/router/router.dart';

class RedirectPage extends StatefulWidget {
  const RedirectPage({super.key});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await routerConfigNotifier.updateRoleAndConfig();
      } on UserNotFound catch (e) {
        debugPrint('UserException: ${e.message}');
        // 如果出现错误，则注销用户并重定向到登录页面
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/sign_in');
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('redirecting.....');
    return Scaffold(
      body: Center(
        child: Custom.spinner(context),
      ),
    );
  }
}
