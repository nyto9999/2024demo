import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/auth_repo.dart';
import 'package:house/const.dart';
import 'package:house/post/bloc/customer_my_posts/customer_my_posts_cubit.dart';
import 'package:house/post/post_repo.dart';

class CustomerMyPostsPage extends StatelessWidget {
  const CustomerMyPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('My Posts'),
            ElevatedButton(
                onPressed: () {
                  context.read<AuthRepo>().authMethods.signOut(context);
                },
                child: const Text('signout'))
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => CustomerMyPostsCubit(context.read<PostRepo>()),
        child: _customerPosts(context),
      ),
    );
  }

  Widget _customerPosts(BuildContext context) {
    return BlocBuilder<CustomerMyPostsCubit, CustomerMyPostsState>(
      builder: (context, state) {
        final cubit = context.read<CustomerMyPostsCubit>();

        return cubit.pagination.streamBuilder(
          (context, snapshot) {
            final posts = snapshot.data;

            if (posts == null || posts.isEmpty) {
              return const Center(child: Text('暫時沒有貼文'));
            }

            return ListView.builder(
              controller: cubit.pagination.scrollController,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(post['title']),
                  subtitle: Text(post['kind']),
                  trailing: Text(
                    (post['createdAt'] as Timestamp).toDate().toString(),
                  ),
                  onTap: () {
                    context
                        .go('/${Const.my_posts}/post/?id=${posts[index].id}');
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
