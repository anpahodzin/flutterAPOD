import 'package:equatable/equatable.dart';
import 'package:flutter_apod/model/post.dart';

abstract class PostState extends Equatable {
  PostState();

  @override
  List get props => [];
}

abstract class PostDataState extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostDataState(
    this.posts,
    this.hasReachedMax,
  );

  @override
  List get props => [posts, hasReachedMax];
}

class PostInitial extends PostState {}

class PostFailure extends PostState {
  final String errorMessage;

  PostFailure(this.errorMessage);
}

class PostRefresh extends PostDataState {
  PostRefresh({
    required List<Post> posts,
    required bool hasReachedMax,
  }) : super(posts, hasReachedMax);

  PostRefresh.fromPostSuccess(PostDataState postSuccess)
      : super(postSuccess.posts, postSuccess.hasReachedMax);

  @override
  String toString() =>
      'PostRefresh { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}

class PostLoading extends PostDataState {
  PostLoading(
    List<Post> posts,
    bool hasReachedMax,
  ) : super(posts, hasReachedMax);

  PostLoading.fromPostSuccess(PostDataState postSuccess)
      : super(postSuccess.posts, postSuccess.hasReachedMax);

  @override
  String toString() =>
      'PostLoading { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}

class PostSuccess extends PostDataState {
  PostSuccess(
    List<Post> posts,
    bool hasReachedMax,
  ) : super(posts, hasReachedMax);

  PostSuccess copyWith({
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostSuccess(
      posts ?? this.posts,
      hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'PostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
