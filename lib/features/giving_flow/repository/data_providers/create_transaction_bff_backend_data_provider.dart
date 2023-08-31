import 'dart:developer';
import 'dart:convert';

import 'package:givt_app_kids/helpers/api_helper.dart';
import 'package:http/http.dart' as http;

import 'package:givt_app_kids/features/giving_flow/models/transaction.dart';

class CreateTransactionBffBackendDataProvider {
  Future<void> createTransaction({required Transaction transaction}) async {
    try {
      final url = Uri.https(
        ApiHelper.apiURL,
        "/givt4kidsservice/v1/transaction/create-transaction",
      );
      var response = await http.post(
        url,
        headers: {
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
