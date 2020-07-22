import 'package:flutter/material.dart';
import 'package:flutter_basic_network/network.dart';
import 'package:flutter_basic_network/post.dart';
import 'package:flutter_basic_network/post_state.dart';
import 'package:flutter_basic_network/repo.dart';
import 'package:http/http.dart' as http;

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
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;
  PostRepository repository =
      PostRepository(network: Network(httpClient: http.Client()));

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
    repository.fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: repository.postStateSubject,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final state = snapshot.data;
              if (state is PostFailure) {
                return Center(
                  child: Text('failed to fetch posts'),
                );
              }
              if (state is PostSuccess) {
                if (state.posts.isEmpty) {
                  return Center(
                    child: Text('no posts'),
                  );
                }
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.posts.length
                        ? BottomLoader()
                        : PostWidget(post: state.posts[index]);
                  },
                  itemCount: state.hasReachedMax
                      ? state.posts.length
                      : state.posts.length + 1,
                  controller: scrollController,
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    repository.dispose();
    super.dispose();
  }

  void onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll - currentScroll <= scrollThreshold) {
      repository.fetchPost();
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        post.id.toString(),
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text('${post.title}'),
      isThreeLine: true,
      subtitle: Text(post.body),
      dense: true,
    );
  }
}