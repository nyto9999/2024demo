import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/helper/const.dart';
import 'package:house/helper.dart';
import 'package:house/home/master_home.dart';
import 'package:house/main.dart';
import 'package:house/notification/master/master_notification.dart';
import 'package:house/tx/pages/master_page/master_application_page.dart';
import 'package:house/tx/pages/master_page/master_my_txs_page/master_my_txs_page.dart';
import 'package:house/tx/pages/master_page/master_tx_ops_page.dart';
import 'package:house/router/initial_routing/initial_routing_config.dart';
import 'package:house/router/master_routing/master_bottom_navigation_page.dart';
import 'package:house/router/router.dart';
import 'package:house/setting/setting_page.dart';

final _masterHomeNavigatorKey = GlobalKey<NavigatorState>();
final _myTxNavigatorKey = GlobalKey<NavigatorState>();
final _masterNotificationNavigatorKey = GlobalKey<NavigatorState>();
final _settingNavigatorKey = GlobalKey<NavigatorState>();

RoutingConfig masterRoutingConfig() {
  return RoutingConfig(
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatoryKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: _masterHomeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: MasterHomePage(),
                  );
                },
                routes: [
                  GoRoute(
                    path: Const.m_tx_ops,
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        child: MasterTxOpsPage(
                          txId: state.uri.queryParameters['id']!,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(navigatorKey: _myTxNavigatorKey, routes: [
            GoRoute(
              path: '/${Const.my_tx}',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: MasterMyTxsPage(),
              ),
            ),
          ]),
          StatefulShellBranch(
            navigatorKey: _masterNotificationNavigatorKey,
            routes: [
              GoRoute(
                path: '/${Const.master_notification}',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: MasterNotification());
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingNavigatorKey,
            routes: [
              GoRoute(
                path: '/setting',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingPage(title: '設定'),
                ),
                routes: [
                  GoRoute(
                    path: Const.master_application,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: MasterApplicationPage(),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return getPage(
            child: MasterBottomNavigationPage(
              child: navigationShell,
            ),
            state: state,
          );
        },
      ),
    ],
    redirect: (context, state) async {
      final user = auth.currentUser;

      // 如果用户未登录并且不是在访问登录或注册页面，则重定向到登录页面
      if (user == null) {
        routerConfigNotifier.value = initialRoutingConfig();
      }

      // 如果用户通过电子邮件和密码登录但未验证电子邮件，则显示消息并重定向到登录页面
      if (user != null && (!state.uri.path.contains('email_verify'))) {
        final isPasswordProvider = user.providerData
            .any((userInfo) => userInfo.providerId == 'password');
        if (isPasswordProvider && !user.emailVerified) {
          await auth.signOut();
          routerConfigNotifier.value = initialRoutingConfig();
        } else {
          return null;
        }
      }

      return null;
    },
  );
}
