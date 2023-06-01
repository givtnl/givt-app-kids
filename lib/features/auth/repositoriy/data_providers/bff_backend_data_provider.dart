import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:givt_app_kids/features/auth/models/auth_request.dart';

class BffBackendDataProvider {
  Future<Map<String, dynamic>> login(AuthRequest authRequest) async {
    final url = Uri.https(
        'dev-backend.givtapp.net', '/givt4kidsservice/v1/Authentication/login');

    try {
      var response = await http.post(
        url,
        body: {
          'userName': authRequest.email,
          'password': authRequest.password,
        },
      );

      log('bff login status code: ${response.statusCode}');

      if (response.statusCode < 400) {
        var decodedBody = json.decode(response.body);
        final itemMap = decodedBody['item'];
        return {
          'email': itemMap['email'],
          'guid': itemMap['userId'],
          'accessToken': itemMap['accessToken'],
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
