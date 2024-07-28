import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/helper/const.dart';
import 'package:house/helper.dart';
import 'package:house/home/customer_home.dart';
import 'package:house/main.dart';
import 'package:house/notification/customer/customer_notification.dart';
import 'package:house/tx/pages/customer_page/add_tx_page.dart';
import 'package:house/tx/pages/customer_page/customer_my_tx_page/customer_my_txs_page.dart';
import 'package:house/tx/pages/customer_page/customer_tx_ops_page.dart';
import 'package:house/tx/pages/master_page/master_application_page.dart';
import 'package:house/router/customer_routing/customer_bottom_navigation_page.dart';
import 'package:house/router/initial_routing/initial_routing_config.dart';
import 'package:house/router/router.dart';
import 'package:house/setting/setting_page.dart';

final _customerHomeNavigatorKey = GlobalKey<NavigatorState>();
final _myTxNavigatorKey = GlobalKey<NavigatorState>();
final _customerNotificationNavigatorKey = GlobalKey<NavigatorState>();
final _settingNavigatorKey = GlobalKey<NavigatorState>();

RoutingConfig customerRoutingConfig() {
  return RoutingConfig(
    routes: [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatoryKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: _customerHomeNavigatorKey,
            routes: [
              GoRoute(
                  path: '/',
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: const CustomerHomePage(title: 'Customer Home'),
                    );
                  },
                  routes: [
                    GoRoute(
                        path: Const.c_add_tx,
                        pageBuilder: (context, state) => const NoTransitionPage(
                              child: CustomerAddTxPage(),
                            )),
                  ])
            ],
          ),
          StatefulShellBranch(navigatorKey: _myTxNavigatorKey, routes: [
            GoRoute(
              path: '/${Const.my_tx}',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const CustomerMyTxsPage(),
              ),
              routes: [
                GoRoute(
                  path: Const.c_tx_ops,
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: CustomerTxOpsPage(
                        txId: state.uri.queryParameters['id']!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(
              navigatorKey: _customerNotificationNavigatorKey,
              routes: [
                GoRoute(
                  path: '/${Const.customer_notification}',
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(
                      child: CustomerNotificationPage(),
                    );
                  },
                ),
              ]),
          StatefulShellBranch(
            navigatorKey: _settingNavigatorKey,
            routes: [
              GoRoute(
                  path: '/${Const.setting}',
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: SettingPage(title: '設定'),
                      ),
                  routes: [
                    GoRoute(
                        path: Const.master_application,
                        pageBuilder: (context, state) => const NoTransitionPage(
                              child: MasterApplicationPage(),
                            ))
                  ]),
            ],
          )
        ],
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return getPage(
            child: CustomerBottomNavigationPage(
              child: navigationShell,
            ),
            state: state,
          );
        },
      ),
    ],
    redirect: (context, state) async {
      final user = auth.currentUser;

      // 如果登入後使用者不存在，則將路由配置重置為初始值
      if (user == null) {
        routerConfigNotifier.value = initialRoutingConfig();
        context.go('/sign_in');
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
