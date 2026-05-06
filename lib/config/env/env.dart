import 'package:envied/envied.dart';
import 'package:injectable/injectable.dart';

part 'env.g.dart';

@lazySingleton
@Envied(path: '.env', useConstantCase: true)
final class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true, defaultValue: '')
  final String? apiKey = _Env.apiKey;
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  final String baseUrl = _Env.baseUrl;
}
