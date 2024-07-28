import 'package:flutter/material.dart';
import 'package:house/main.dart';

class MasterApplicationPage extends StatelessWidget {
  const MasterApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Master Service Application'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                firestoreRepo.addMasterApplication(name: 'Tony');
              },
              child: const Text('Submit'),
            ),
          ],
        ));
  }
}
