import 'package:envied/envied.dart';

part 'app_secret.g.dart';

@Envied(path: '.env')
abstract class AppSecret {
  @EnviedField(varName: 'PASSIO_KEY')
  static const String passioKey = _AppSecret.passioKey;
}
