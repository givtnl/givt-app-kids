import 'package:givt_app_kids/core/app/app_config.dart';
import 'package:givt_app_kids/core/app/bootstrap.dart';
import 'package:givt_app_kids/core/app/givt_app.dart';

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
