import 'dart:convert';
import 'dart:developer';

import 'package:givt_app_kids/core/exceptions/givt_server_exception.dart';
import 'package:givt_app_kids/core/network/network.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

class APIService {
  APIService(
    this._apiURL,
  );

  Client client = InterceptedClient.build(
    requestTimeout: const Duration(seconds: 10),
    interceptors: [
      TokenInterceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  String _apiURL;

  String get apiURL => _apiURL;

  void updateApiUrl(String url) {
    _apiURL = url;
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/Authentication/login');

    var response = await client.post(
      url,
      body: body,
    );

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> loginByVoucherCode(
      Map<String, dynamic> body) async {
    final url =
        Uri.https(_apiURL, '/givt4kidsservice/v1/Authentication/voucher');

    var response = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> loginByFamilyName(
      Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/Authentication/event');

    var response = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<List<dynamic>> fetchAllProfiles() async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/profiles');

    var response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      return decodedBody['item']['profiles'] as List<dynamic>;
    }
  }

  Future<dynamic> fetchChildDetails(String id) async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/profiles/$id');

    var response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      final temp = decodedBody['item']['profile'];
      return temp;
    }
  }

  Future<Map<String, dynamic>> fetchOrganisationDetails(String mediumId) async {
    final url = Uri.https(_apiURL,
        'givt4kidsservice/v1/organisation/organisation-detail/$mediumId');

    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      return decodedBody['item'];
    }
  }

  Future<void> createTransaction({required Transaction transaction}) async {
    final url = Uri.https(
        _apiURL, '/givt4kidsservice/v1/transaction/create-transaction');

    var response = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(transaction.toJson()),
    );

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      var decodedBody = jsonDecode(response.body);
      log(decodedBody.toString());
    }
  }

  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> body) async {
    final url = Uri.https(
        _apiURL, '/givt4kidsservice/v1/Authentication/refresh-accesstoken');

    var response = await client.post(
      url,
      body: body,
    );

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<List<dynamic>> fetchHistory(
      String childId, Map<String, dynamic> body) async {
    final url = Uri.https(_apiURL,
        '/givt4kidsservice/v1/transaction/transaction-history/$childId');

    var response = await client.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      var decodedBody = jsonDecode(response.body);
      final itemMap = decodedBody['items'];
      return itemMap;
    }
  }

  Future<List<dynamic>> fetchTags() async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/Organisation/tags');

    var response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      var decodedBody = json.decode(response.body);
      var itemsList = decodedBody['items'];
      return itemsList;
    }
  }

  Future<List<dynamic>> getRecommendedOrganisations(
      Map<String, dynamic> body) async {
    final url =
        Uri.https(_apiURL, '/givt4kidsservice/v1/Organisation/recommendations');

    var response = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      var decodedBody = json.decode(response.body);
      var itemsList = decodedBody['items'] as List<dynamic>;
      return itemsList;
    }
  }

  Future<List<dynamic>> getSchoolEventOrganisations() async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/organisation/event');

    var response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      var decodedBody = json.decode(response.body);
      var itemsList = decodedBody['items'] as List<dynamic>;
      return itemsList;
    }
  }

  Future<List<dynamic>> fetchAvatars() async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/profiles/avatars');

    final response = await client.get(url);

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemMap = decodedBody['items'];
    return itemMap as List<dynamic>;
  }

  Future<void> editProfile(
    String childGUID,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/profiles/$childGUID');

    var response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
  }

  Future<Map<String, dynamic>?> fetchFamilyGoal() async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/goal/family/latest');
    final response = await client.get(url);
    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final decodedBody = jsonDecode(response.body);
    final item = decodedBody['item'];
    return item;
  }
  // Future<List<dynamic>> fetchImpactGroups() async {
  //   final url = Uri.https(_apiURL, '/givtservice/v1/groups');
  //   final response = await client.get(url);

  //   if (response.statusCode >= 400 && response.statusCode < 500) {
  //     return [];
  //   }

  //   if (response.statusCode >= 500) {
  //     throw GivtServerFailure(
  //       statusCode: response.statusCode,
  //       body: jsonDecode(response.body) as Map<String, dynamic>,
  //     );
  //   }

  //   final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
  //   final itemMap = decodedBody['items']! as List<dynamic>;
  //   return itemMap;
  // }

  Future<List<dynamic>> fetchImpactGroups() async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/group');
    final response = await client.get(url);
    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
    final itemMap = decodedBody['items']! as List<dynamic>;
    return itemMap;
  }
}
