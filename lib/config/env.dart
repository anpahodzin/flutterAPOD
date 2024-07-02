import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  static const String apodUrl = "https://api.nasa.gov/planetary/apod";
  @EnviedField(varName: 'apod_api_key')
  static const String apodApiKey = _Env.apodApiKey;
}