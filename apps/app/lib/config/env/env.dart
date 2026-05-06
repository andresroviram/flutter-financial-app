import 'package:core/env/i_env_config.dart';
import 'package:envied/envied.dart';
import 'package:injectable/injectable.dart';

part 'env.g.dart';

@LazySingleton(as: IEnvConfig)
@Envied(path: '.env', useConstantCase: true)
final class Env implements IEnvConfig {
  @EnviedField(varName: 'API_KEY', obfuscate: true, defaultValue: '')
  @override
  final String? apiKey = _Env.apiKey;
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  @override
  final String baseUrl = _Env.baseUrl;
}
