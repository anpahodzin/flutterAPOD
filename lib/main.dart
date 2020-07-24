import 'package:flutter/material.dart';
import 'package:flutter_basic_network/data/network.dart';
import 'package:flutter_basic_network/data/repo.dart';
import 'package:flutter_basic_network/screen/home_page.dart';
import 'package:http/http.dart' as http;

final PostRepository repository =
    PostRepository(network: Network(httpClient: http.Client()));

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Infinite Scroll',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
        ),
        body: HomePage(repository: repository),
      ),
    );
  }
}