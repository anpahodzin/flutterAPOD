enum MediaType { IMAGE, VIDEO }

MediaType mediaTypeFromRaw(String mediaType) {
  switch (mediaType) {
    case "image":
      return MediaType.IMAGE;
    case "video":
      return MediaType.VIDEO;
  }
  return null;
}

String mediaTypeToRaw(MediaType mediaType) {
  switch (mediaType) {
    case MediaType.IMAGE:
      return "image";
      break;
    case MediaType.VIDEO:
      return "video";
  }
  return null;
}
