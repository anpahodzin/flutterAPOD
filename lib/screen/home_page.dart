import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic_network/data/repo.dart';
import 'package:flutter_basic_network/utils/date.dart';
import 'package:flutter_basic_network/model/post.dart';
import 'package:flutter_basic_network/model/post_state.dart';

class HomePage extends StatefulWidget {
  final PostRepository repository;

  const HomePage({Key key, @required this.repository}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  final scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
    widget.repository.fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: refresh,
      child: StreamBuilder(
          stream: widget.repository.postStateSubject,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final state = snapshot.data;
              if (state is PostFailure) {
                return Center(
                  child: Text('failed to fetch posts'),
                );
              }
              if (state is PostDataState) {
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
    widget.repository.dispose();
    super.dispose();
  }

  void onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll - currentScroll <= scrollThreshold) {
      widget.repository.fetchPost();
    }
  }

  Future<void> refresh() {
    return widget.repository.refreshPost();
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
    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(children: [
          Container(
            width: double.infinity,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: post.url,
              errorWidget: (context, url, error) => CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: post.hdurl,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
//            color: (post.videoUrl == null) ? Colors.white : Colors.red,
            child: Container(
              padding: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
              child: ListTile(
                leading: Text(
                  post.date.formatDate(),
                  style: postWidgetStyle,
                ),
                title: Text(
                  post.title,
                  maxLines: 2,
                  style: postWidgetStyle.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                subtitle: Text(
                  post.explanation,
                  maxLines: 2,
                  style: postWidgetStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                dense: true,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

final postWidgetStyle = TextStyle(
  fontSize: 10.0,
  color: Colors.white,
);
