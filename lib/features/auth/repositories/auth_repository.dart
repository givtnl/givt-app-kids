import 'dart:convert';

import 'package:givt_app_kids/core/network/network.dart';
import 'package:givt_app_kids/features/auth/models/auth_request.dart';
import 'package:givt_app_kids/features/auth/models/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin AuthRepository {
  Future<Session> refreshToken();
  Future<Session> login(AuthRequest authRequest);
  Future<bool> logout();
}

class AuthRepositoryImpl with AuthRepository {
  AuthRepositoryImpl(
    this._prefs,
    this._apiService,
  );

  final SharedPreferences _prefs;
  final APIService _apiService;

  @override
  Future<Session> login(AuthRequest authRequest) async {
    final response = await _apiService.login(
      {
        'username': authRequest.email,
        'password': authRequest.password,
        'grant_type': 'password',
      },
    );

    final sessionJson = response['item'];
    final session = Session.fromJson(sessionJson);

    await _prefs.setString(
      Session.tag,
      jsonEncode(session.toJson()),
    );

    return session;
  }

  @override
  Future<bool> logout() async => _prefs.clear();

  @override
  Future<Session> refreshToken() async {
    final currentSession = _prefs.getString(Session.tag);
    if (currentSession == null) {
      return const Session.empty();
    }
    final session = Session.fromJson(
      jsonDecode(currentSession) as Map<String, dynamic>,
    );
    final response = await _apiService.refreshToken(
      {
        'refreshToken': session.refreshToken,
      },
    );
    final sessionJson = response['item'];
    final newSession = Session.fromJson(sessionJson);
    await _prefs.setString(
      Session.tag,
      jsonEncode(newSession.toJson()),
    );
    return newSession;
  }
}
