import 'package:flutter_apod/data/datasource/database.dart';
import 'package:flutter_apod/data/network.dart';
import 'package:flutter_apod/model/post.dart';
import 'package:flutter_apod/model/post_state.dart';
import 'package:rxdart/rxdart.dart';

class PostRepository {
  final Network network;
  static const int POST_COUNT = 10;

  PostRepository({required this.network});

  final BehaviorSubject<PostState> postStateSubject =
      BehaviorSubject.seeded(PostInitial());

  Future<void> fetchPost() async {
    try {
      final lastState = postStateSubject.value;
      if (lastState is PostInitial ||
          lastState is PostFailure ||
          lastState is PostRefresh) {
        final endDate = DateTime.now();
        final startDate = endDate.add(const Duration(days: -POST_COUNT));
        List<Post> posts = await network.loadPosts(startDate, endDate);
        await DBProvider.db.insertsPosts(posts);
        posts = await DBProvider.db.getPosts(startDate, endDate);
        postStateSubject.add(PostSuccess(posts, false));
        return;
      }
      if (lastState is PostSuccess && !lastState.hasReachedMax) {
        postStateSubject.add(PostLoading.fromPostSuccess(lastState));
        final endDate = lastState.posts.last.date.add(const Duration(days: -1));
        final startDate = endDate.add(const Duration(days: -POST_COUNT));
        List<Post> posts = await network.loadPosts(startDate, endDate);
        await DBProvider.db.insertsPosts(posts);
        posts = await DBProvider.db.getPosts(startDate, endDate);
        final newState = posts.isEmpty
            ? lastState.copyWith(hasReachedMax: true)
            : PostSuccess(
                lastState.posts + posts,
                 false,
              );
        postStateSubject.add(newState);
        return;
      }
    } on Exception catch (error) {
      postStateSubject.add(PostFailure(error.toString()));
    }
  }

  Future<void> refreshPost() {
    final lastState = postStateSubject.value as PostDataState;
    postStateSubject.value = PostRefresh.fromPostSuccess(lastState);
    return fetchPost();
  }

  void dispose() {
    postStateSubject.close();
  }
}
