import 'dart:async';
import 'dart:convert';

import 'package:flutter_basic_network/post.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

class Network {
  final http.Client httpClient;

  Network({@required this.httpClient});

  Future<List<Post>> loadPosts(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    developer.log(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Post(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}
