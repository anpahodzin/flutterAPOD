import 'package:sprintf/sprintf.dart';

class YoutubeParser {
  static const YOUTUBE_REGEX =
      "^.*((youtu.be/)|(v/)|(/u/\\w/)|(embed/)|(watch\\?))\\??v?=?([^#&?]*).*";
  static const YOUTUBE_PREVIEW = "https://img.youtube.com/vi/%s/sddefault.jpg";
  static const YOUTUBE_PREVIEW_HD =
      "https://img.youtube.com/vi/%s/hqdefault.jpg";

  static String getImageLinkFromUrl(String format, String url) {
    final videoUrl = RegExp(YOUTUBE_REGEX).firstMatch(url)?.group(7);
    return sprintf(format, [videoUrl]);
  }
}
