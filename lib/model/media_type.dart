enum MediaType { IMAGE, VIDEO }

MediaType mediaTypeFromRaw(String mediaType) {
  switch (mediaType) {
    case "image":
      return MediaType.IMAGE;
    case "video":
      return MediaType.VIDEO;
  }
  return MediaType.IMAGE;
}

String mediaTypeToRaw(MediaType mediaType) {
  switch (mediaType) {
    case MediaType.IMAGE:
      return "image";
    case MediaType.VIDEO:
      return "video";
  }
}
