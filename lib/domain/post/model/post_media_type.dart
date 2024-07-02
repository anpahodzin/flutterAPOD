class PostType {
  late String name;

  String toRaw() {
    return name;
  }

  static PostType fromRaw(String mediaType) {
    switch (mediaType) {
      case ImagePostType.NAME:
        return ImagePostType();
      case VideoPostType.NAME:
        return VideoPostType();
    }
    return ImagePostType();
  }
}

class ImagePostType extends PostType {
  @override
  String name = NAME;
  static const NAME = "image";
}

class VideoPostType extends PostType {
  @override
  String name = NAME;
  static const NAME = "video";
}
