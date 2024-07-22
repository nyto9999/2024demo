import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/post/bloc/master_get_all_posts/master_get_all_posts_cubit.dart';
import 'package:house/post/post_repo.dart';

class MasterHomePage extends StatelessWidget {
  const MasterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build master home');
    return Scaffold(
      appBar: AppBar(
        title: const Text('師傅首頁'),
      ),
      body: BlocProvider(
        create: (context) => MasterGetAllPostsCubit(context.read<PostRepo>()),
        child: _getPostsExcludingMasterSelf(context),
      ),
    );
  }

  Widget _getPostsExcludingMasterSelf(BuildContext context) {
    return BlocBuilder<MasterGetAllPostsCubit, MasterGetAllPostsState>(
      builder: (context, state) {
        final cubit = context.read<MasterGetAllPostsCubit>();

        return cubit.pagination.streamBuilder(
          (context, snapshot) {
            final posts = snapshot.data;

            if (posts == null || posts.isEmpty) {
              return const Center(child: Text('暫時沒有貼文'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                await cubit.refreshPosts();
              },
              child: ListView.builder(
                controller: cubit.pagination.scrollController,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(post['title']),
                    subtitle: Text(post['kind']),
                    trailing: Text(
                        (post['createdAt'] as Timestamp).toDate().toString()),
                    onTap: () {
                      context.go('/post/?id=${posts[index].id}');
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
