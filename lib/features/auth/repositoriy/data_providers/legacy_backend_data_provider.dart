import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:givt_app_kids/features/auth/models/auth_request.dart';
import 'package:givt_app_kids/helpers/api_helper.dart';

class LegacyBackendDataProvider {
  Future<Map<String, dynamic>> login(AuthRequest authRequest) async {
    final url = Uri.https(ApiHelper.apiURL, ApiHelper.loginPath);

    try {
      var response = await http.post(
        url,
        body: {
          'grant_type': 'password',
          'userName': authRequest.email,
          'password': authRequest.password,
        },
      );

      log('legacy login status code: ${response.statusCode}');

      if (response.statusCode < 400) {
        var decodedBody = json.decode(response.body);
        final responseMap = decodedBody as Map<String, dynamic>;
        return {
          'email': responseMap['Email'],
          'guid': responseMap['GUID'],
          'accessToken': responseMap['access_token'],
        };
      } else {
        throw Exception(response.body);
      }
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }
}
