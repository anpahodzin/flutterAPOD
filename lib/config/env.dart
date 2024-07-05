import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'APOD_URL')
  static const String apodUrl = _Env.apodUrl;
  @EnviedField(varName: 'APOD_API_KEY')
  static const String apodApiKey = _Env.apodApiKey;
}