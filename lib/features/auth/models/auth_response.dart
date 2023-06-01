class AuthResponse {
  AuthResponse({
    required this.email,
    required this.guid,
    required this.accessToken,
  });

  final String email;
  final String guid;
  final String accessToken;

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      email: map['email'],
      guid: map['guid'],
      accessToken: map['accessToken'],
    );
  }
}
