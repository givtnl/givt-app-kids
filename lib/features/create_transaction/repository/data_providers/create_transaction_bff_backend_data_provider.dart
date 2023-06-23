import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:givt_app_kids/features/create_transaction/models/transaction.dart';

class CreateTransactionBffBackendDataProvider {
  Future<void> createTransaction({required Transaction transaction}) async {
    const hardcodedToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI0NkRBNTU5RC1CQ0M4LTQ0RjgtQjVFOC0wNzQwRjMxNEQzODMiLCJ1bmlxdWVfbmFtZSI6ImdpdnQtdGVhbUBnaXZ0YXBwLm5ldCIsInJvbGUiOiJnaXZ0T3BlcmF0b3IiLCJBcHBJZCI6IkludGVybmFsIGRhc2hib2FyZCAoUmV0b29sKSIsIm5iZiI6MTY4MTgxMDY4OSwiZXhwIjoxOTIxODEwNjg5LCJpYXQiOjE2ODE4MTA2ODksImlzcyI6Imh0dHBzOi8vYXBpLmdpdnRhcHAubmV0In0.y4QL_WZcPGwpmD471RmnMwFtMFlNYvzcpbiblqgHkBw';
    try {
      final url = Uri.https(
        "dev-backend.givtapp.net",
        "/givt4kidsservice/v1/transaction/create-transaction",
      );
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $hardcodedToken",
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
