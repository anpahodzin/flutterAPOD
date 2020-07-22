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

  void fetchPost() async {
    try {
      final lastState = postStateSubject.value;
      if (lastState is PostInitial || lastState is PostFailure) {
        final posts = await network.loadPosts(0, postLimit);
        postStateSubject.add(PostSuccess(posts: posts, hasReachedMax: false));
        return;
      }
      if (lastState is PostSuccess) {
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
    } catch (error) {
      postStateSubject.add(PostFailure());
    }
  }

  void refreshPost(){
    postStateSubject.value = PostInitial();
    fetchPost();
  }

  void dispose() {
    postStateSubject.close();
  }
}
