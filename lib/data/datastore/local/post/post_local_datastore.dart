import 'dart:developer';

import 'package:flutter_apod/data/datastore/local/post/model/post_entity.dart';
import 'package:flutter_apod/data/datastore/local/post/post_dao.dart';
import 'package:flutter_apod/model/post.dart';

import '../../post_datastore.dart';

class PostLocalDataStore implements PostDataStore {
  late PostDao dao;

  PostLocalDataStore({required this.dao});

  @override
  Future<List<Post>> getPosts(DateTime startDate, DateTime endDate) async {
    final postEntities = await dao.getPosts(
        startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch);
    log("room <= $startDate ${postEntities.length}");
    return postEntities.toPost();
  }

  @override
  Future<void> insertPosts(List<Post> posts) {
    return dao.insertPosts(posts.toPostEntity());
  }

  @override
  Future<void> clear() {
    return dao.clear();
  }
}
