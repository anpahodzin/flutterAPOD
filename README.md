# flutter_apod

A Flutter NASA Astronomy Picture of the Day application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Before running!
- add `apod_api_key={secret key}` with a secret key for [API NASA](https://api.nasa.gov/) to `.env` file
- generate `env.g.dart` file using the command `flutter packages pub run build_runner build` (To automatically run it, whenever a file changes,
  use `flutter packages pub run build_runner watch`)

Or you can rename `.env_test` to `.env` and add a secret key from [API NASA](https://api.nasa.gov/)