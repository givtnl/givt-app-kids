class ApiHelper {
  static String apiURL = const String.fromEnvironment('API_URL');
  static const String loginPath = "/oauth2/token";
  static const String profilePath = "/profiles";

  static String transactionPath(String guid) {
    return "/profiles/$guid/transactions";
  }
}
