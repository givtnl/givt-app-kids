import 'dart:convert';
import 'dart:developer';

import 'package:givt_app_kids/core/exceptions/givt_server_exception.dart';
import 'package:givt_app_kids/core/network/network.dart';
import 'package:givt_app_kids/features/giving_flow/create_transaction/models/transaction.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

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

    log('login status code: ${response.statusCode}');

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

    log('login by voucher status code: ${response.statusCode}');

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
  }

  Future<List<dynamic>> fetchProfiles(String parentGuid) async {
    final url = Uri.https(_apiURL, '/givt4kidsservice/v1/User/get-children');

    var response = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(parentGuid),
    );

    log('fetch profiles status code: ${response.statusCode}');

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

    log('get organisation details status code: ${response.statusCode}');

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

    log('create transaction status code: ${response.statusCode}');

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

    log('refresh-accesstoken status code: ${response.statusCode}');

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

    log('fetch donation history pageNr: ${body['pageNumber']}, status code: ${response.statusCode}');

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

    log('get-tags response code: ${response.statusCode}');

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

    log('get-recommended-organisations status code: ${response.statusCode}');

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

    final response = await client.get(
      url,
      //not sure do we need headers here?
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    log('fetch avatars response code: ${response.statusCode}');

    // if (response.statusCode >= 400) {
    //   throw GivtServerException(
    //     statusCode: response.statusCode,
    //     body: response.body.isNotEmpty
    //         ? jsonDecode(response.body) as Map<String, dynamic>
    //         : null,
    //   );
    // }
    // final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;

    final decodedBody = _getMockAvatars();
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
      //not sure do we need headers here?
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    log('edit-profile status code: ${response.statusCode}');

    if (response.statusCode >= 400) {
      throw GivtServerException(
        statusCode: response.statusCode,
        body: response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : null,
      );
    }
  }
}

/////////////////////

Map<String, dynamic> _getMockAvatars() {
  return {
    "items": [
      {
        "filename": "hero1.svg",
        "url":
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero1.svg",
      },
      {
        "filename": "hero2.svg",
        "url":
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero2.svg",
      },
      {
        "filename": "hero3.svg",
        "url":
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero3.svg",
      },
      {
        "filename": "hero4.svg",
        "url":
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero4.svg",
      },
      {
        "filename": "hero5.svg",
        "url":
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero5.svg",
      },
      {
        "filename": "hero6.svg",
        "url":
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero6.svg",
      },
      {
        "filename": "hero7.svg",
        "url":
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero7.svg",
      },
      {
        "filename": "hero8.svg",
        "url":
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero8.svg",
      },
      {
        "filename": "hero9.svg",
        "url":
            "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero9.svg",
      },
      // {
      //   "filename": "hero1.svg",
      //   "url":
      //       "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero1.svg",
      // },
      // {
      //   "filename": "hero2.svg",
      //   "url":
      //       "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero2.svg",
      // },
      // {
      //   "filename": "hero3.svg",
      //   "url":
      //       "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero3.svg",
      // },
      // {
      //   "filename": "hero4.svg",
      //   "url":
      //       "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero4.svg",
      // },
      // {
      //   "filename": "hero5.svg",
      //   "url":
      //       "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero5.svg",
      // },
      // {
      //   "filename": "hero6.svg",
      //   "url":
      //       "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero6.svg",
      // },
      // {
      //   "filename": "hero7.svg",
      //   "url":
      //       "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero7.svg",
      // },
      // {
      //   "filename": "hero8.svg",
      //   "url":
      //       "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero8.svg",
      // },
      // {
      //   "filename": "hero9.svg",
      //   "url":
      //       "https://givtstoragedebug.blob.core.windows.net/public/cdn/avatars/Hero9.svg",
      // }
    ]
  };
}
