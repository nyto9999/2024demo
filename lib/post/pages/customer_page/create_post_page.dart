import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house/auth/helper/custom_style.dart';
import 'package:house/post/post_repo.dart';

class CustomerCreatePostPage extends StatefulWidget {
  const CustomerCreatePostPage({super.key});

  @override
  State<CustomerCreatePostPage> createState() => _CustomerCreatePostPageState();
}

class _CustomerCreatePostPageState extends State<CustomerCreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _kindController = TextEditingController();
  final _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Page'),
      ),
      body: Padding(
        padding: Custom.padding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _kind(),
              _postTextfield(),
              Custom.gap,
              _createPostButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kind() {
    return FutureBuilder<QuerySnapshot>(
      future: context.read<PostRepo>().getServiceKinds(),
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

  Widget _createPostButton() {
    return ElevatedButton(
      onPressed: () {
        context
            .read<PostRepo>()
            .customer
            .addPost(kind: _kindController.text, title: _postController.text);
      },
      child: const Text('Create Post'),
    );
  }
}
