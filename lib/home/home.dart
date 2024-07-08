import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/auth_repo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    print('build home');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  final usecase =
                      RepositoryProvider.of<AuthRepo>(context).authUsecases;

                  print(usecase.currentUser);
                },
                child: const Text('user')),
          ),
        
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RepositoryProvider.of<AuthRepo>(context).authUsecases.signOut();
          context.pushReplacement('/login');
        },
      ),
    );
  }
}
