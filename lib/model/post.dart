import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_basic_network/extension/date.dart';
import 'package:sprintf/sprintf.dart';

class Post extends Equatable {
  final String copyright;
  final DateTime date;
  final String explanation;
  final String hdurl;
  final MediaType mediaType;
  final String title;
  final String url;
  final String videoUrl;

  Post({
    this.copyright,
    this.date,
    this.explanation,
    this.hdurl,
    this.mediaType,
    this.title,
    this.url,
    this.videoUrl,
  });

  static Post fromRaw(dynamic rawPost) {
    final mediaType = MediaTypeConverter.fromRaw(rawPost['media_type']);
    String hdurl, url, videoUrl;
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
      copyright: rawPost['copyright'],
      date: (rawPost['date'] as String).formatDateApod(),
      explanation: rawPost['explanation'],
      mediaType: mediaType,
      title: rawPost['title'],
      hdurl: hdurl,
      url: url,
      videoUrl: videoUrl,
    );
  }

  @override
  List get props =>
      [copyright, date, explanation, hdurl, mediaType, title, url];

  @override
  String toString() => 'Post { id: $date }';
}

enum MediaType { IMAGE, VIDEO }

class MediaTypeConverter {
  static MediaType fromRaw(String mediaType) {
    switch (mediaType) {
      case "image":
        return MediaType.IMAGE;
      case "video":
        return MediaType.VIDEO;
    }
    return null;
  }
}

class YoutubeParser {
  static const YOUTUBE_REGEX =
      "^.*((youtu.be/)|(v/)|(/u/\\w/)|(embed/)|(watch\\?))\\??v?=?([^#&?]*).*";
  static const YOUTUBE_PREVIEW = "https://img.youtube.com/vi/%s/sddefault.jpg";
  static const YOUTUBE_PREVIEW_HD =
      "https://img.youtube.com/vi/%s/hqdefault.jpg";

  static String getImageLinkFromUrl(String format, String url) {
    log("message format=$format url=$url");
    final videoUrl = RegExp(YOUTUBE_REGEX).firstMatch(url)?.group(7);
    return sprintf(format, [videoUrl]);
  }
}