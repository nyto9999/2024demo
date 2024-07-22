import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house/main.dart';

import 'package:house/router/customer_routing/customer_routing_config.dart';
import 'package:house/router/initial_routing/initial_routing_config.dart';
import 'package:house/router/master_routing/master_routing_config.dart';

final rootNavigatoryKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter.routingConfig(
  debugLogDiagnostics: true,
  routingConfig: routerConfigNotifier,
  navigatorKey: rootNavigatoryKey,
);

final RoleAwareRoutingConfigNotifier routerConfigNotifier =
    RoleAwareRoutingConfigNotifier(initialRoutingConfig());

class RoleAwareRoutingConfigNotifier extends ValueNotifier<RoutingConfig> {
  RoleAwareRoutingConfigNotifier(super.value);

  Future<void> updateRoleAndConfig({
    String? newRole,
  }) async {
    newRole ??= await firestoreRepo.getUserRoleById(auth.currentUser?.uid);

    switch (newRole) {
      case 'customer':
        value = customerRoutingConfig();
        debugPrint('RoleAwareRoutingConfigNotifier: customer $newRole');
        break;
      case 'master':
        value = masterRoutingConfig();
        debugPrint('RoleAwareRoutingConfigNotifier: master $newRole');
        break;
      default:
        value = initialRoutingConfig();
        debugPrint('RoleAwareRoutingConfigNotifier: init $newRole');
    }
  }
}

class UserNotFound implements Exception {
  final String message;
  UserNotFound(this.message);
}
