import 'package:flutter_apod/data/datastore/post_datastore.dart';
import 'package:flutter_apod/data/post_repo.dart';
import 'package:flutter_apod/model/post.dart';
import 'package:flutter_apod/model/post_state.dart';
import 'package:rxdart/rxdart.dart';

class PostDataRepository extends PostRepository {
  final PostDataStore remote;
  final PostDataStore local;

  static const int POST_COUNT = 10;

  PostDataRepository({required this.remote, required this.local});

  final BehaviorSubject<PostState> _postStateSubject =
      BehaviorSubject.seeded(PostInitial());

  @override
  Stream<PostState> getPostStream() {
    return _postStateSubject.stream;
  }

  Future<List<Post>> retrievePosts(DateTime startDate, DateTime endDate,
      {bool forceNetwork = false}) async {
    if (forceNetwork) {
      return await updateRemotePosts(startDate, endDate);
    }
    final posts = await local.getPosts(startDate, endDate);
    if (posts.length >= POST_COUNT) {
      return posts;
    }
    return await updateRemotePosts(startDate, endDate);
  }

  Future<List<Post>> updateRemotePosts(
      DateTime startDate, DateTime endDate) async {
    final posts = await remote.getPosts(startDate, endDate);
    local.insertPosts(posts);
    return posts;
  }

  @override
  Future<void> fetchPost() async {
    try {
      final lastState = _postStateSubject.value;
      if (lastState is PostInitial ||
          lastState is PostFailure ||
          lastState is PostRefresh) {
        final endDate = DateTime.now();
        final startDate = endDate.add(Duration(days: -POST_COUNT));
        final posts = await retrievePosts(startDate, endDate);
        _postStateSubject.add(PostSuccess(posts, false));
      }
      if (lastState is PostSuccess && !lastState.hasReachedMax) {
        _postStateSubject.add(PostLoading.fromPostSuccess(lastState));
        final endDate = lastState.posts.last.date.add(Duration(days: -1));
        final startDate = endDate.add(Duration(days: -POST_COUNT));
        final posts = await retrievePosts(startDate, endDate);
        final newState = posts.isEmpty
            ? lastState.copyWith(hasReachedMax: true)
            : PostSuccess(
                lastState.posts + posts,
                false,
              );
        _postStateSubject.add(newState);
      }
    } on Exception catch (error) {
      _postStateSubject.add(PostFailure(error.toString()));
    }
  }

  Future<void> refreshPost() async{
    final lastState = _postStateSubject.value as PostDataState;
    _postStateSubject.value = PostRefresh.fromPostSuccess(lastState);
    await remote.clear();
    return fetchPost();
  }

  void dispose() {
    _postStateSubject.close();
  }
}
