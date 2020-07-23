import 'package:equatable/equatable.dart';
import 'package:flutter_basic_network/extension/date.dart';

class Post extends Equatable {
  final String copyright;
  final DateTime date;
  final String explanation;
  final String hdurl;
  final String mediaType;
  final String title;
  final String url;

  Post(
      {this.copyright,
      this.date,
      this.explanation,
      this.hdurl,
      this.mediaType,
      this.title,
      this.url})
      : super([copyright, date, explanation, hdurl, mediaType, title, url]);

  Post.fromRaw(dynamic rawPost)
      : copyright = rawPost['copyright'],
        date = (rawPost['date'] as String).formatDateApod(),
        explanation = rawPost['explanation'],
        hdurl = rawPost['hdurl'],
        mediaType = rawPost['media_type'],
        title = rawPost['title'],
        url = rawPost['url'];

  @override
  String toString() => 'Post { id: $date }';
}
