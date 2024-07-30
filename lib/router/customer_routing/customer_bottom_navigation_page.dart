import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/fcm_service.dart';
import 'package:house/notification/customer/remote_messages/remote_messages_cubit.dart';

class CustomerBottomNavigationPage extends StatefulWidget {
  const CustomerBottomNavigationPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<CustomerBottomNavigationPage> createState() =>
      _CustomerBottomNavigationPageState();
}

class _CustomerBottomNavigationPageState
    extends State<CustomerBottomNavigationPage>
    with AutomaticKeepAliveClientMixin<CustomerBottomNavigationPage> {
  int notificationCount = 0; // 初始化通知计数

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();

    FcmService.onMessageCallback = (RemoteMessage message) {
      setState(() {
        context.read<RemoteMessages>().addMessage(message);
        notificationCount++;
        print('notificationCount: $notificationCount');
      });
    };

    FcmService.onBackgroundMessageCallback = (RemoteMessage message) {
      context.read<RemoteMessages>().addMessage(message);
      print('bg notificationCount: $notificationCount');
      setState(() {
        notificationCount++;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.child.currentIndex,
        onTap: (index) {
          if (index == 2) {
            setState(() {
              notificationCount = 0;
            });
          }
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '我的訂單',
          ),
          BottomNavigationBarItem(
            icon: notificationCount > 0
                ? Badge(
                    label: Text(
                      notificationCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: const Icon(Icons.notifications),
                  )
                : const Icon(Icons.notifications),
            label: '通知',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notification_important_rounded),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
