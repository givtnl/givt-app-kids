import 'package:givt_app_kids/app_config.dart';
import 'package:givt_app_kids/bootstrap.dart';
import 'package:givt_app_kids/givt_app.dart';

void main() {
  var configuredApp = AppConfig(
    flavorName: 'development',
    apiBaseUrl: 'dev-backend.givt.app',
    amplitudePublicKey: 'e02f6615e27048c072e1058476fce30b',
  );

  bootstrap(
    () => GivtApp(configuredApp),
  );
}
