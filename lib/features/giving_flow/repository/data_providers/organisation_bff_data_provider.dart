import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/organisation.dart';

class OrganisationBffDataProvider {
  Future<Organisation> fetchOrganisationDetails(String? mediumId) async {
    final url = Uri.https(
      'dev-backend.givtapp.net',
      'givt4kidsservice/v1/organisation/organisation-detail/$mediumId',
    );
    String authorizationToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI0NkRBNTU5RC1CQ0M4LTQ0RjgtQjVFOC0wNzQwRjMxNEQzODMiLCJ1bmlxdWVfbmFtZSI6ImdpdnQtdGVhbUBnaXZ0YXBwLm5ldCIsInJvbGUiOiJnaXZ0T3BlcmF0b3IiLCJBcHBJZCI6IkludGVybmFsIGRhc2hib2FyZCAoUmV0b29sKSIsIm5iZiI6MTY4MTgxMDY4OSwiZXhwIjoxOTIxODEwNjg5LCJpYXQiOjE2ODE4MTA2ODksImlzcyI6Imh0dHBzOi8vYXBpLmdpdnRhcHAubmV0In0.y4QL_WZcPGwpmD471RmnMwFtMFlNYvzcpbiblqgHkBw';
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
