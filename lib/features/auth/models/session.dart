class Session {
  Session({
    required this.email,
    required this.userGUID,
    required this.accessToken,
    required this.refreshToken,
    required this.expires,
    required this.expiresIn,
  });

  factory Session.fromLoginData(
    String userGUID,
    String email,
    String accessToken,
    String refreshToken,
    String expires,
    int expiresIn,
  ) {
    return Session(
      userGUID: userGUID,
      email: email,
      accessToken: accessToken,
      expires: expires,
      expiresIn: expiresIn,
      refreshToken: refreshToken,
    );
  }

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        email: json['email'] as String,
        userGUID: json['userId'] as String,
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        expires: json['expirationDate'] as String,
        expiresIn: json['expiresIn'] as int,
      );
  const Session.empty()
      : userGUID = '',
        email = '',
        accessToken = '',
        refreshToken = '',
        expires = '',
        expiresIn = 0;

  final String userGUID;
  final String email;
  final String accessToken;
  final String refreshToken;
  final String expires;
  final int expiresIn;

  bool get isExpired {
    final now = DateTime.now().toUtc();
    if (expires.isEmpty) return false;
    final expiresDate = DateTime.parse(expires).subtract(
      const Duration(
        minutes: 20,
      ),
    );
    return now.isAfter(expiresDate);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userGUID,
        'email': email,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expirationDate': expires,
        'expiresIn': expiresIn,
      };

  @override
  String toString() {
    return 'Session{userId: $userGUID, email: $email, accessToken: $accessToken, refreshToken: $refreshToken, expires: $expires, expiresIn: $expiresIn}';
  }

  static String tag = 'Session';
}
