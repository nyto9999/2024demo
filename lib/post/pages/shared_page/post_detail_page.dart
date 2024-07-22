import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/bloc/user_role/user_role_state.dart';
import 'package:house/auth/helper/custom_style.dart';
import 'package:house/firestore/model/quote.dart';
import 'package:house/helper.dart';
import 'package:house/post/bloc/customer_get_post_quotes/customer_get_post_quotes_cubit.dart';
import 'package:house/post/bloc/post_detail/post_detail_cubit.dart';
import 'package:house/post/pages/master_page/widgets/add_quote_dialog.dart';
import 'package:house/post/post_repo.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostDetailCubit(
            postRepo: context.read<PostRepo>(),
            postId: postId,
          )..getPostById(postId),
        ),
        BlocProvider(
          create: (context) => CustomerGetPostQuotesCubit(
            context.read<PostRepo>(),
          )..getPostQuotes(postId),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Post Detail: $postId'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<PostDetailCubit, PostDetailState>(
            builder: (context, state) {
              return switch (state) {
                PostDetailLoading() =>
                  const Center(child: CircularProgressIndicator()),
                PostDetailHasData() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Title: ${state.post.title ?? 'No title'}'),
                      Text('Kind: ${state.post.kind ?? 'No kind'}'),
                      Text('Owner: ${state.post.owner ?? 'No owner'}'),
                      Text(
                          'Created At: ${state.post.createdAt?.toString() ?? 'No date'}'),
                      context.read<UserRoleCubit>().hasMasterPermission()
                          ? _masterQuotationButton(context, state.post.owner)
                          : _customerQuotationListView(context),
                    ],
                  ),
                PostDetailError() =>
                  Center(child: Text('Error: ${state.message}')),
                _ => const SizedBox.shrink(),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _customerQuotationListView(BuildContext context) {
    return BlocBuilder<CustomerGetPostQuotesCubit, CustomerGetPostQuotesState>(
      builder: (context, state) {
        return switch (state) {
          CustomerGetPostQuotesLoaded() => ListView.builder(
              shrinkWrap: true,
              itemCount: state.quotes.length,
              itemBuilder: (context, index) {
                var quote = QuoteModel.fromMap(state.quotes[index].data());
                return ListTile(
                  title: Text('Quote: ${quote.quoteAmount}'),
                  subtitle: Column(
                    children: [
                      Text('Master ID: ${quote.masterId}'),
                      Text('Created At: ${quote.createdAt}'),
                      Text('Updated At: ${quote.updatedAt}'),
                    ],
                  ),
                  trailing: Custom.defaultButton(
                      child: const Text('接受'),
                      onPressed: () {
                        // final passData = {
                        //   'postId': postId,
                        //   'quoteId': state.quotes[index].id,
                        //   'customer_id': auth.currentUser?.uid,
                        //   'master_id': quote['master_id'],
                        //   'quoteAmount': quote['quoteAmount'],
                        // };

                        context.push('/payment',
                            extra: quote
                                .copyWith(postId: postId)
                                .toJson(MapType.dateTime));
                      }),
                );
              },
            ),
          CustomerGetPostQuotesError() =>
            Center(child: Text('Error: ${state.message}')),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  ElevatedButton _masterQuotationButton(
      BuildContext context, String? postOwnerId) {
    return ElevatedButton(
      child: const Text('報價'),
      onPressed: () {
        addQuotationDialog(
          context: context,
          postId: postId,
          postOwnerId: postOwnerId,
        );
      },
    );
  }
}
