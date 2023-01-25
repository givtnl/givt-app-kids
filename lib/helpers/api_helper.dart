class ApiHelper {
  static const String apiURL = "givt-debug-api.azurewebsites.net";
  static const String loginPath = "/oauth2/token";
  static const String profilePath = "/profiles";

  static String transactionPath(String guid) {
    return "profiles/$guid/transactions";
  }
}
