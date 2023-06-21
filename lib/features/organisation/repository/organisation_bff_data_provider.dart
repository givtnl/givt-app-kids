import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/organisation.dart';

class OrganisationBffDataProvider {
  Future<Organisation> fetchOrganisationDetails(String? mediumId) async {
    final url = Uri.https(
      'dev-backend.givtapp.net',
      '/api/v3/campaigns',
      {
        'code': mediumId,
      },
    );
    try {
      var response = await http.get(url);
      log('bff fetch organisation status code: ${response.statusCode}');
      if (response.statusCode < 400) {
        Map<String, dynamic> decoded = json.decode(response.body);
        var organisation = Organisation.fromMap(decoded);
        return organisation;
      } else {
        throw Exception(response.body);
      }
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }
}
