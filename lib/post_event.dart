import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {}

class PostFetch extends PostEvent {
  int lastPost;

  PostFetch({this.lastPost});

  @override
  String toString() => 'Fetch';
}