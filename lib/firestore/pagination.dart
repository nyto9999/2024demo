import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Pagination {
  int page = 0; // 新增變量來跟踪當前頁數
  int pageSize = 10;
  List<DocumentSnapshot> output = [];
  bool isFetching = false;
  bool hasMore = true;
  Future<QuerySnapshot<Map<String, dynamic>>> Function(
      DocumentSnapshot? lastDocument)? apiCall;
  ScrollController scrollController;
  DateTime _lastRefreshTime = DateTime.fromMillisecondsSinceEpoch(0);
  final StreamController<List<DocumentSnapshot>> _controller =
      StreamController<List<DocumentSnapshot>>.broadcast();
  Stream<List<DocumentSnapshot>> get stream => _controller.stream;

  Pagination({required this.pageSize}) : scrollController = ScrollController() {
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      fetchPage();
    }
  }

  void paginateUntilMax(
      Future<QuerySnapshot<Map<String, dynamic>>> Function(
              DocumentSnapshot? lastDocument)
          newApiCall) {
    resetState();
    apiCall = newApiCall;
    fetchPage();
  }

  Future<void> fetchPage() async {
    if (isFetching || apiCall == null || !hasMore) return;

    isFetching = true;

    try {
      final lastDocument = output.isNotEmpty ? output.last : null;
      page++;
      debugPrint('Fetching page $page');
      final result = await apiCall!(lastDocument);

      if (result.docs.isEmpty) {
        debugPrint('已經沒有更多數據了');
        hasMore = false;
      } else {
        output.addAll(result.docs);
        _controller.sink.add(output);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isFetching = false;
    }
  }

  void resetState() {
    output.clear();
    hasMore = true;
    page = 0; // 重置頁數
    _controller.sink.add(output);
  }

  StreamBuilder<List<DocumentSnapshot>> streamBuilder(
      Widget Function(
        BuildContext context,
        AsyncSnapshot<List<DocumentSnapshot>> snapshot,
      ) builder) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: stream,
      builder: builder,
    );
  }

  //fixme: 這個方法是為了解決快速下拉刷新時，多次觸發刷新操作的問題
  Future<void> refresh() async {
    final currentTime = DateTime.now();
    if (currentTime.difference(_lastRefreshTime).inSeconds < 3) {
      debugPrint('刷新操作被忽略，距离上次刷新不足3秒');
      return;
    } else {
      _lastRefreshTime = currentTime;
      resetState();
      await fetchPage();
    }
  }

  void dispose() {
    _controller.close();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }
}
