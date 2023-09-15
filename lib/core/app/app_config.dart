class AppConfig {
  AppConfig(
      {required this.flavorName,
      required this.apiBaseUrl,
      required this.amplitudePublicKey});

  final String flavorName;
  final String apiBaseUrl;
  final String amplitudePublicKey;
}
