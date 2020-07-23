import 'package:flutter_basic_network/network.dart';
import 'package:flutter_basic_network/post_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class PostRepository {
  final Network network;
  static const int postLimit = 10;

  PostRepository({@required this.network});

  final BehaviorSubject<PostState> postStateSubject =
      BehaviorSubject.seeded(PostInitial());

  Future<void> fetchPost() async {
    try {
      final lastState = postStateSubject.value;
      if (lastState is PostInitial ||
          lastState is PostFailure ||
          lastState is PostRefresh) {
        final posts = await network.loadPosts(0, postLimit);
        postStateSubject.add(PostSuccess(posts: posts, hasReachedMax: false));
        return;
      }
      if (lastState is PostSuccess && !lastState.hasReachedMax) {
        postStateSubject.add(PostLoading.fromPostSuccess(lastState));
        final posts =
            await network.loadPosts(lastState.posts.length, postLimit);
        final newState = posts.isEmpty
            ? lastState.copyWith(hasReachedMax: true)
            : PostSuccess(
                posts: lastState.posts + posts,
                hasReachedMax: false,
              );
        postStateSubject.add(newState);
        return;
      }
    } on Exception catch (error) {
      postStateSubject.add(PostFailure(error.toString()));
    }
  }

  Future<void> refreshPost() {
    final lastState = postStateSubject.value;
    postStateSubject.value = PostRefresh.fromPostSuccess(lastState);
    return fetchPost();
  }

  void dispose() {
    postStateSubject.close();
  }
}
