import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:house/firestore/model/post.dart';
import 'package:house/post/post_repo.dart';
import 'dart:async';

part 'post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final PostRepo postRepo;
  final String postId;
  StreamSubscription<Post>? _postSubscription;
  Post post = Post.empty();

  PostDetailCubit({required this.postRepo, required this.postId})
      : super(PostDetailInitial());

  void getPostById(String postId) {
    emit(PostDetailLoading());

    // function
    _postSubscription = postRepo.master.getPostById(postId).listen((event) {
      post = event;

      emit(PostDetailHasData(post));
    }, onError: (e) {
      emit(PostDetailError(e.toString()));
    });
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }
}
