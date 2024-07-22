import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:house/firestore/pagination.dart';
import 'package:house/main.dart';
import 'package:house/post/post_repo.dart';

part 'master_get_all_posts_state.dart';

class MasterGetAllPostsCubit extends Cubit<MasterGetAllPostsState> {
  final PostRepo postRepo;
  final Pagination pagination;
  final String uid;

  MasterGetAllPostsCubit(this.postRepo)
      : uid = auth.currentUser?.uid ?? '',
        pagination = Pagination(pageSize: 10),
        super(MasterGetAllPostsInitial()) {
    _init(uid);
  }

  void _init(String uid) {


    // function
    pagination.paginateUntilMax((lastDocument) {
      return postRepo.master.getPostsExcludingMasterSelf(
        uid: uid,
        lastDocument: lastDocument,
        pageSize: pagination.pageSize,
      );
    });

    pagination.stream.listen((posts) {
      emit(MasterGetAllPostsPaginating(
          posts: posts, hasMore: pagination.hasMore));
    });
  }

  Future<void> refreshPosts() async {
    await pagination.refresh();
    _init(uid);
  }

  @override
  Future<void> close() {
    pagination.dispose();
    return super.close();
  }
}
