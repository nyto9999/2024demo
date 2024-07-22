import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerBottomNavigationPage extends StatefulWidget {
  const CustomerBottomNavigationPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<CustomerBottomNavigationPage> createState() =>
      _CustomerBottomNavigationPageState();
}

class _CustomerBottomNavigationPageState
    extends State<CustomerBottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.child.currentIndex,
        onTap: (index) {
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '我的訂單',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '通知',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important_rounded),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
