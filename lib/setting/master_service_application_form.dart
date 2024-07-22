import 'package:flutter/material.dart';

class MasterServiceApplicationForm extends StatefulWidget {
  const MasterServiceApplicationForm({super.key});

  @override
  State<MasterServiceApplicationForm> createState() =>
      _MasterServiceApplicationFormState();
}

class _MasterServiceApplicationFormState
    extends State<MasterServiceApplicationForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Master Service Application Form'),
        ),
        body: ElevatedButton(
          onPressed: () {},
          child: const Text('Submit'),
        ));
  }
}
