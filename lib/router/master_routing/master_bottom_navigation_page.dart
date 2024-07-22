import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MasterBottomNavigationPage extends StatefulWidget {
  const MasterBottomNavigationPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<MasterBottomNavigationPage> createState() =>
      _MasterBottomNavigationPageState();
}

class _MasterBottomNavigationPageState
    extends State<MasterBottomNavigationPage> {
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '師傅訂單',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '通知',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
