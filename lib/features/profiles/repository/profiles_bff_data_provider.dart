import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ProfilesBffDataProvider {
  Future<List<dynamic>> fetchProfiles(String parentGuid) async {
    final url = Uri.https(
        'dev-backend.givtapp.net', '/givt4kidsservice/v1/User/get-children');

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(parentGuid),
      );

      log('bff fetch profiles status code: ${response.statusCode}');

      if (response.statusCode < 400) {
        var decodedBody = json.decode(response.body);
        final itemMap = decodedBody['item'];
        return itemMap;
      } else {
        throw Exception(response.body);
      }
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }
}
