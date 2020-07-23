import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_basic_network/extension/date.dart';
import 'package:flutter_basic_network/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class Network {
  final http.Client httpClient;

  Network({@required this.httpClient});

  static const String URL = "https://api.nasa.gov/planetary/apod";
  static const String API_KEY = "NfwThGAgLfofnjjLoy9z03Fm9M63L8Vw4e9uBD0l";

  Future<List<Post>> loadPosts(DateTime startDate, DateTime endDate) async {
    final start = startDate.formatDateApod();
    final end = endDate.formatDateApod();
    final response = await httpClient
        .get("$URL?api_key=$API_KEY&start_date=$start&end_date=$end");
    log("http => ${response.request.url.toString()}");
    log("http <= ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.reversed.map((rawPost) {
        return Post.fromRaw(rawPost);
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}
