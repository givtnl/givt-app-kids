import 'package:givt_app_kids/app_config.dart';
import 'package:givt_app_kids/bootstrap.dart';
import 'package:givt_app_kids/givt_app.dart';

void main() {
  var configuredApp = AppConfig(
    flavorName: 'production',
    apiBaseUrl: 'api.givt.app',
    amplitudePublicKey: '05353d3a94c0d52d75cc1e7d13faa8e1',
  );

  bootstrap(
    () => GivtApp(configuredApp),
  );
}
