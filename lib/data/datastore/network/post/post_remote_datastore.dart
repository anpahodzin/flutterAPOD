import 'package:flutter_apod/data/datastore/network/post/post_network.dart';
import 'package:flutter_apod/model/post.dart';
import 'package:flutter_apod/utils/date.dart';

import '../../post_datastore.dart';

class PostRemoteDataStore implements PostDataStore {
  final PostNetwork _network;

  PostRemoteDataStore(this._network);

  @override
  Future<List<Post>> getPosts(DateTime startDate, DateTime endDate) {
    final start = startDate.formatDateApod();
    final end = endDate.formatDateApod();
    return _network.loadPosts(start, end);
  }

  @override
  Future<void> insertPosts(List<Post> posts) {
    throw UnsupportedError("Don't work this.");
  }

  @override
  Future<void> clear() {
    throw UnsupportedError("Don't work this.");
  }
}
