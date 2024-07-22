part of 'master_get_all_posts_cubit.dart';

sealed class MasterGetAllPostsState extends Equatable {
  const MasterGetAllPostsState();

  @override
  List<Object> get props => [];
}

final class MasterGetAllPostsInitial extends MasterGetAllPostsState {}

final class MasterGetAllPostsPaginating extends MasterGetAllPostsState {
  final List<DocumentSnapshot> posts;
  final bool hasMore;

  const MasterGetAllPostsPaginating({required this.posts, required this.hasMore});

  @override
  List<Object> get props => [posts, hasMore];
}

final class MasterGetAllPostsError extends MasterGetAllPostsState {
  final String message;

  const MasterGetAllPostsError(this.message);

  @override
  List<Object> get props => [message];
}
