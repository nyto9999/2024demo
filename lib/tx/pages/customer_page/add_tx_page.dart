import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:house/firestore/model/transaction.dart';
import 'package:house/helper/custom_style.dart';
import 'package:house/main.dart';

import 'package:intl/intl.dart';

class CustomerAddTxPage extends StatefulWidget {
  const CustomerAddTxPage({super.key});

  @override
  State<CustomerAddTxPage> createState() => _CustomerAddTxPageState();
}

class _CustomerAddTxPageState extends State<CustomerAddTxPage> {
  final _formKey = GlobalKey<FormState>();
  final _kindController = TextEditingController();
  final _postController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tx Page'),
      ),
      body: Padding(
        padding: Custom.padding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _kind(),
              Custom.gap,
              _postTextfield(),
              Custom.gap,
              _addressTextfield(),
              Custom.gap,
              _dateTextfield(),
              Custom.gap,
              _addTxButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kind() {
    return FutureBuilder<QuerySnapshot>(
      future: firestoreRepo.getServiceKinds(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        List<DropdownMenuItem<String>> kindItems = [];
        for (var doc in snapshot.data!.docs) {
          kindItems.add(DropdownMenuItem(
            value: doc.id,
            child: Text(doc.id),
          ));
        }

        return DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: '種類',
            border: OutlineInputBorder(),
          ),
          items: kindItems,
          onChanged: (value) {
            setState(() {
              _kindController.text = value as String;
            });
          },
        );
      },
    );
  }

  Widget _postTextfield() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: '刊登',
        border: OutlineInputBorder(),
      ),
      controller: _postController,
    );
  }

  Widget _addTxButton() {
    return ElevatedButton(
      onPressed: () async {
        final t = Tx(
          kind: _kindController.text,
          postDesc: _postController.text,
          address: _addressController.text,
          customerName: auth.currentUser?.displayName,
          customerId: auth.currentUser?.uid,
          postStatus: 'pending',
          workDate: DateFormat('yyyy-MM-dd HH:mm').parse(_dateController.text),
        );

        await firestoreRepo.addTransaction(transaction: t);
      },
      child: const Text('Create Post'),
    );
  }

  Widget _addressTextfield() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: '施工地址',
        border: OutlineInputBorder(),
      ),
      controller: _addressController,
    );
  }

  Widget _dateTextfield() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: '施工日期和時間',
        border: OutlineInputBorder(),
      ),
      controller: _dateController,
      readOnly: true,
      onTap: () async {
        DateTime initialDate = DateTime.now();
        TimeOfDay initialTime = TimeOfDay.now();

        if (_dateController.text.isNotEmpty) {
          DateTime parsedDate =
              DateFormat('yyyy-MM-dd HH:mm').parse(_dateController.text);
          initialDate = parsedDate;
          initialTime =
              TimeOfDay(hour: parsedDate.hour, minute: parsedDate.minute);
        }

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          selectableDayPredicate: (DateTime date) {
            // Disable dates before today
            return date
                .isAfter(DateTime.now().subtract(const Duration(days: 1)));
          },
        );

        if (pickedDate != null) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );

          if (pickedTime != null) {
            DateTime finalDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            String formattedDate =
                DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);
            _dateController.text = formattedDate;
          }
        }
      },
    );
  }
}
