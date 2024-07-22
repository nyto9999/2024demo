import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/auth_repo.dart';
import 'package:house/home/redirect_page.dart';

RoutingConfig initialRoutingConfig() {
  return RoutingConfig(
    routes: [
      GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: RedirectPage(),
            );
          }),
      GoRoute(
        path: '/sign_in',
        pageBuilder: (context, state) => NoTransitionPage(
          child:
              RepositoryProvider.of<AuthRepo>(context).buildLoginForm(context),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'sms',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: RepositoryProvider.of<AuthRepo>(context)
                    .buildSmsSignInForm(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/forget_password',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: RepositoryProvider.of<AuthRepo>(context)
                .buildForgetPasswordPage(),
          );
        },
      ),
      GoRoute(
          path: '/sign_up',
          pageBuilder: (context, state) {
            return NoTransitionPage(
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
                  child: RepositoryProvider.of<AuthRepo>(context)
                      .buildEmailVerifyPage(),
                );
              },
            ),
          ]),
    ],
    redirect: (context, state) {
      final path = state.uri.path;
      final validPaths = {
        '/',
        '/sign_in',
        '/sign_in/sms',
        '/forget_password',
        '/sign_up',
        '/sign_up/email_verify'
      };
      if (!validPaths.contains(path)) {
        return '/';
      }
      return null;
    },
  );
}
