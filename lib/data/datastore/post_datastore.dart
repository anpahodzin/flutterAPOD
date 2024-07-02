import 'package:flutter_apod/model/post.dart';

abstract class PostDataStore{

  Future<List<Post>> getPosts(DateTime startDate, DateTime endDate) ;

  Future<void> insertPosts(List<Post> posts);

  Future<void> clear();
}