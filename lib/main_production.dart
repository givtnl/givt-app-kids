import 'package:givt_app_kids/core/app/app_config.dart';
import 'package:givt_app_kids/core/app/bootstrap.dart';
import 'package:givt_app_kids/core/app/givt_app.dart';

void main() {
  var configuredApp = AppConfig(
    flavorName: 'production',
    apiBaseUrl: 'backend.givt.app',
    amplitudePublicKey: '05353d3a94c0d52d75cc1e7d13faa8e1',
  );

  bootstrap(
    () => GivtApp(configuredApp),
  );
}
