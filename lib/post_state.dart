import 'package:equatable/equatable.dart';
import 'package:flutter_basic_network/post.dart';

abstract class PostState extends Equatable {
  PostState();

  @override
  Set get props => Set();
}

abstract class PostDataState extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostDataState({
    this.posts,
    this.hasReachedMax,
  });

  @override
  Set get props => Set.from([posts, hasReachedMax]);
}

class PostInitial extends PostState {}

class PostFailure extends PostState {
  final String errorMessage;

  PostFailure(this.errorMessage);
}

class PostRefresh extends PostDataState {
  PostRefresh({
    List<Post> posts,
    bool hasReachedMax,
  }) : super(posts: posts, hasReachedMax: hasReachedMax);

  PostRefresh.fromPostSuccess(PostSuccess postSuccess)
      : super(
            posts: postSuccess.posts, hasReachedMax: postSuccess.hasReachedMax);

  @override
  String toString() =>
      'PostRefresh { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}

class PostLoading extends PostDataState {
  PostLoading({
    List<Post> posts,
    bool hasReachedMax,
  }) : super(posts: posts, hasReachedMax: hasReachedMax);

  PostLoading.fromPostSuccess(PostSuccess postSuccess)
      : super(
            posts: postSuccess.posts, hasReachedMax: postSuccess.hasReachedMax);

  @override
  String toString() =>
      'PostLoading { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}

class PostSuccess extends PostDataState {
  PostSuccess({
    List<Post> posts,
    bool hasReachedMax,
  }) : super(posts: posts, hasReachedMax: hasReachedMax);

  PostSuccess copyWith({
    List<Post> posts,
    bool hasReachedMax,
  }) {
    return PostSuccess(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'PostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
