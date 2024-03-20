import 'dart:convert';

import 'package:givt_app_kids/core/injection/injection.dart';
import 'package:givt_app_kids/core/logging/logging.dart';
import 'package:givt_app_kids/features/auth/models/session.dart';
import 'package:givt_app_kids/features/auth/repositories/auth_repository.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TokenInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionString = prefs.getString(Session.tag);
      final correlationId = const Uuid().v4();
      if (!request.headers.containsKey('Content-Type')) {
        request.headers['Content-Type'] = 'application/json';
      }
      request.headers['Accept'] = 'application/json';
      request.headers['Correlation-Id'] = correlationId.toString();

      await LoggingInfo.instance.info(
        '${request.method}: ${request.url} - Correlation-Id: $correlationId',
      );

      if (sessionString == null) {
        return request;
      }

      final session = Session.fromJson(
        jsonDecode(sessionString) as Map<String, dynamic>,
      );

      if (session.accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        'Error while adding token to request: $e',
        methodName: stackTrace.toString(),
      );
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async =>
      response;

  @override
  Future<bool> shouldInterceptRequest() => Future.value(true);

  @override
  Future<bool> shouldInterceptResponse() => Future.value(true);
}

/// This is the retry policy that will be used by the [InterceptedClient]
/// to retry requests that failed due to an expired token.
class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    ///This is where we need to update our token on 401 response
    if (response.statusCode == 401) {
      await getIt<AuthRepository>().refreshToken();
      return true;
    }
    return false;
  }
}
