import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_apod/config/env.dart';
import 'package:flutter_apod/domain/api_exception.dart';
import 'package:flutter_apod/domain/post/model/post.dart';
import 'package:http/http.dart' as http;

class PostNetwork {
  final http.Client _client;

  PostNetwork(this._client);

  // todo
  static const String URL = Env.apodUrl;
  static const String API_KEY = Env.apodApiKey;

  Future<List<Post>> loadPosts(String startDate, String endDate) async {
    final url = Uri.parse(
        "$URL?api_key=$API_KEY&start_date=$startDate&end_date=$endDate");
    final response = await _client.get(url);

    log("http => ${response.request?.url.toString()}"); // develop
    log("http <= ${response.statusCode} ${response.body}"); // develop

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.reversed.map((rawPost) {
        return Post.fromJson(rawPost);
      }).toList();
    } else {
      throw ApiException(response.statusCode, 'error fetching posts');
    }
  }
}
