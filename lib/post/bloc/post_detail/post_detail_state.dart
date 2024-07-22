part of 'post_detail_cubit.dart';

sealed class PostDetailState extends Equatable {
  const PostDetailState();

  @override
  List<Object> get props => [];
}

final class PostDetailInitial extends PostDetailState {}

final class PostDetailError extends PostDetailState {
  final String message;

  const PostDetailError(this.message);

  @override
  List<Object> get props => [message];
}

final class PostDetailLoading extends PostDetailState {}

final class PostDetailHasData extends PostDetailState {
  final Post post;

  const PostDetailHasData(this.post);

  @override
  List<Object> get props => [post];
}
