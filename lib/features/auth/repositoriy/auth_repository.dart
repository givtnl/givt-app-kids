import 'package:givt_app_kids/features/auth/models/auth_response.dart';
import 'package:givt_app_kids/features/auth/models/auth_request.dart';
import 'package:givt_app_kids/features/auth/repositoriy/data_providers/bff_backend_data_provider.dart';
import 'package:givt_app_kids/features/auth/repositoriy/data_providers/legacy_backend_data_provider.dart';

class AuthRepository {
  Future<AuthResponse> login(AuthRequest authRequest) async {
    // final legacyBackend = LegacyBackendDataProvider();
    final bffBackend = BffBackendDataProvider();
    final response = await bffBackend.login(authRequest);
    return AuthResponse.fromMap(response);
  }
}
