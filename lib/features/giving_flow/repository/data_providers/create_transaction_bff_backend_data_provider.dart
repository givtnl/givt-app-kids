import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:givt_app_kids/secrets.dart';

import 'package:givt_app_kids/features/giving_flow/models/transaction.dart';

class CreateTransactionBffBackendDataProvider {
  Future<void> createTransaction({required Transaction transaction}) async {
    try {
      final url = Uri.https(
        "dev-backend.givtapp.net",
        "/givt4kidsservice/v1/transaction/create-transaction",
      );
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $authorizationToken",
          'Content-Type': 'application/json',
        },
        body: json.encode(transaction.toJson()),
      );
      log("createTransaction [bff] STATUS CODE: ${response.statusCode}");
      if (response.statusCode < 400) {
        var decodedBody = json.decode(response.body);
        log(decodedBody.toString());
      } else {
        throw Exception(response.body);
      }
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }
}
