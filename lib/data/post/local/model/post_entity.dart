import 'package:floor/floor.dart';
import 'package:flutter_apod/domain/post/model/post.dart';
import 'package:flutter_apod/domain/post/model/post_media_type.dart';

@entity
class PostEntity {
  final String? copyright;
  @primaryKey
  final int date;
  final String explanation;
  final String hdurl;
  final String mediaType;
  final String title;
  final String url;
  final String? videoUrl;
  final bool favorite;

  PostEntity({
    this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.title,
    required this.url,
    required this.videoUrl,
    required this.favorite,
  });

  Post toPost() {
    return Post(
      copyright: copyright,
      date: DateTime.fromMillisecondsSinceEpoch(date),
      explanation: explanation,
      hdurl: hdurl,
      mediaType: PostType.fromRaw(mediaType),
      title: title,
      url: url,
      favorite: favorite,
    );
  }
}

extension PostEntityExtension on Post {
  PostEntity toPostEntity() {
    return PostEntity(
        copyright: copyright,
        date: date.millisecondsSinceEpoch,
        explanation: explanation,
        hdurl: hdurl,
        mediaType: mediaType.name,
        title: title,
        url: url,
        videoUrl: videoUrl,
        favorite: favorite);
  }
}

extension ToPost on List<PostEntity>{
  List<Post> toPost(){
    return map((e) => e.toPost()).toList();
  }
}

extension ToPostEntity on List<Post>{
  List<PostEntity> toPostEntity(){
    return map((e) => e.toPostEntity()).toList();
  }
}
