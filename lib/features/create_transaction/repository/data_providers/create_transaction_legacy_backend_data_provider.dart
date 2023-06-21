import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:givt_app_kids/features/create_transaction/models/transaction.dart';

class CreateTransactionLegacyBackendDataProvider {
  Future<void> createTransaction(
      {required Transaction transaction, String accessToken = ''}) async {
    try {
      final url = Uri.https(
        "kids-production-api.azurewebsites.net",
        "/profiles/${transaction.parentGuid}/transactions",
      );
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "destinationName": transaction.destinationName,
          "amount": transaction.amount,
        }),
      );
      log("[createTransaction] STATUS CODE: ${response.statusCode}");
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
