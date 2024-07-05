import 'package:flutter_apod/domain/post/model/post_state.dart';

abstract class PostRepository {

  Stream<PostState> getPostStream();

  Future<void> fetchPost();

  Future<void> refreshPost();

  void dispose();
}
