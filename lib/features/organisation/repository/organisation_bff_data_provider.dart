import 'dart:developer';
import 'dart:convert';

import 'package:givt_app_kids/secrets.dart';
import 'package:http/http.dart' as http;

import '../models/organisation.dart';

class OrganisationBffDataProvider {
  Future<Organisation> fetchOrganisationDetails(String? mediumId) async {
    final url = Uri.https(
      'dev-backend.givtapp.net',
      'givt4kidsservice/v1/organisation/organisation-detail/$mediumId',
    );
    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authorizationToken',
      });
      log('bff fetch organisation status code: ${response.statusCode}');
      if (response.statusCode < 400) {
        Map<String, dynamic> decoded = json.decode(response.body);
        var organisation = Organisation.fromMap(decoded['item']);
        log('organisation: ${organisation.name}');
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
