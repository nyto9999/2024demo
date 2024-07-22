part of 'customer_my_posts_cubit.dart';

sealed class CustomerMyPostsState extends Equatable {
  const CustomerMyPostsState();

  @override
  List<Object> get props => [];
}

class CustomerMyPostsInitial extends CustomerMyPostsState {}

class CustomerMyPostsLoading extends CustomerMyPostsState {}

class CustomerMyPostsPaginating extends CustomerMyPostsState {
  final List<DocumentSnapshot> posts;
  final bool hasMore;

  const CustomerMyPostsPaginating({required this.posts, required this.hasMore});

  @override
  List<Object> get props => [posts, hasMore];
}

class CustomerMyPostsNoUser extends CustomerMyPostsState {}

class CustomerMyPostsError extends CustomerMyPostsState {
  final String message;

  const CustomerMyPostsError(this.message);

  @override
  List<Object> get props => [message];
}
