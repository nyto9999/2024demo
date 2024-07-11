import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/auth_repo.dart';
import 'package:house/home/home.dart';

// [GoRouter] Full paths for routes:
//            ├─/login
//            │ └─/login/sms
//            ├─/register
//            │ └─/register/email_verify
//            ├─/forget_password
//            └─ (ShellRoute)
//              ├─/
//              ├─/b
//              └─/c
// [GoRouter] setting initial location /
final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
        path: '/sign_in',
        pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: RepositoryProvider.of<AuthRepo>(context)
                  .buildLoginForm(context),
            ),
        routes: <RouteBase>[
          GoRoute(
            path: 'sms',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: RepositoryProvider.of<AuthRepo>(context)
                    .buildSmsSignInForm(),
              );
            },
          ),
        ]),
    GoRoute(
      path: '/forget_password',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: state.pageKey,
          child: RepositoryProvider.of<AuthRepo>(context)
              .buildForgetPasswordPage(),
        );
      },
    ),
    GoRoute(
        path: '/sign_up',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: RepositoryProvider.of<AuthRepo>(context)
                .buildEmailRegisterForm(),
          );
        },
        routes: [
          //email verify
          GoRoute(
            path: 'email_verify',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: RepositoryProvider.of<AuthRepo>(context)
                    .buildEmailVerifyPage(),
              );
            },
          ),
        ]),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return GlobalListener(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomePage(
                title: '',
              )),
        ),
        GoRoute(
          path: '/b',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ScreenB(),
          ),
        ),
        GoRoute(
          path: '/c',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const ScreenC(),
          ),
        ),
      ],
    ),
  ],
  redirect: (context, state) async {
    final authRepo = RepositoryProvider.of<AuthRepo>(context);
    final user = authRepo.authUsecases.firebaseAuth.currentUser;
    final inThesePages = state.uri.path.startsWith('/sign_in') ||
        state.uri.path.startsWith('/sign_up') ||
        state.uri.path.startsWith('/forget_password');

    // 如果用户未登录并且不是在访问登录或注册页面，则重定向到登录页面
    if (user == null && !inThesePages) {
      return '/sign_in';
    }

    // 如果用户通过电子邮件和密码登录但未验证电子邮件，则显示消息并重定向到登录页面
    if (user != null && (!state.uri.path.contains('email_verify'))) {
      final isPasswordProvider = user.providerData
          .any((userInfo) => userInfo.providerId == 'password');
      if (isPasswordProvider && !user.emailVerified) {
        await authRepo.authUsecases.firebaseAuth.signOut();
        return '/sign_in';
      } else {
        return null;
      }
    }

    return null;
  },
);

class GlobalListener extends StatefulWidget {
  const GlobalListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<GlobalListener> createState() => _GlobalListenerState();

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/')) {
      return 0;
    }
    if (location.startsWith('/b')) {
      return 1;
    }
    if (location.startsWith('/c')) {
      return 2;
    }
    return 0;
  }
}

class _GlobalListenerState extends State<GlobalListener> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'B Screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important_rounded),
            label: 'C Screen',
          ),
        ],
        currentIndex: GlobalListener._calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/b');
        break;
      case 2:
        context.go('/c');
        break;
    }
  }
}

class ScreenB extends StatelessWidget {
  const ScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Screen B'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/b/details');
              },
              child: const Text('View B details'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The third screen in the bottom navigation bar.
class ScreenC extends StatelessWidget {
  /// Constructs a [ScreenC] widget.
  const ScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Screen C'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/c/details');
              },
              child: const Text('View C details'),
            ),
          ],
        ),
      ),
    );
  }
}
