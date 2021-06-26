import 'package:equatable/equatable.dart';
import 'package:flutter_basic_network/utils/date.dart';
import 'package:flutter_basic_network/utils/youtube.dart';

import 'media_type.dart';

class Post extends Equatable {
  final String? copyright;
  final DateTime date;
  final String explanation;
  final String hdurl;
  final MediaType mediaType;
  final String title;
  final String url;
  final String? videoUrl;
  final bool favorite;

  Post({
    this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.title,
    required this.url,
    this.videoUrl,
    this.favorite = false,
  });

  factory Post.fromJson(Map<String, dynamic> rawPost) {
    final mediaType = mediaTypeFromRaw(rawPost['media_type']);
    String hdurl, url;
    String? videoUrl;
    switch (mediaType) {
      case MediaType.IMAGE:
        hdurl = rawPost['hdurl'];
        url = rawPost['url'];
        break;
      case MediaType.VIDEO:
        hdurl = YoutubeParser.getImageLinkFromUrl(
            YoutubeParser.YOUTUBE_PREVIEW_HD, rawPost['url']);
        url = YoutubeParser.getImageLinkFromUrl(
            YoutubeParser.YOUTUBE_PREVIEW, rawPost['url']);
        videoUrl = rawPost['url'];
        break;
    }
    return Post(
      copyright: rawPost['copyright'] ?? null,
      date: (rawPost['date'] as String).formatDateApod(),
      explanation: rawPost['explanation'],
      mediaType: mediaType,
      title: rawPost['title'],
      hdurl: hdurl,
      url: url,
      videoUrl: videoUrl,
      favorite: rawPost['favorite'] ?? false,
    );
  }

  factory Post.fromStorageJson(Map<String, dynamic> rawPost) => Post(
        copyright: rawPost['copyright'],
        date: DateTime.fromMillisecondsSinceEpoch(rawPost['date']),
        explanation: rawPost['explanation'],
        mediaType: mediaTypeFromRaw(rawPost['media_type']),
        title: rawPost['title'],
        hdurl: rawPost['hdurl'],
        url: rawPost['url'],
        videoUrl: rawPost['videoUrl'],
        favorite: rawPost['favorite'] == 1,
      );

  Map<String, dynamic> toStorageJson() {
    final like = (favorite) ? 1 : 0;
    return {
      "copyright": copyright,
      "date": date.millisecondsSinceEpoch,
      "explanation": explanation,
      "hdurl": hdurl,
      "media_type": mediaTypeToRaw(mediaType),
      "title": title,
      "url": url,
      "videoUrl": videoUrl,
      "favorite": like,
    };
  }

  @override
  List get props =>
      [copyright, date, explanation, hdurl, mediaType, title, url];

  @override
  String toString() => 'Post { date: ${date.toIso8601String()} }';
}
