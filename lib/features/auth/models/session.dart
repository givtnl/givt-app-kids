import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const Session._();

  const factory Session({
    required String email,
    required String userId,
    required String accessToken,
    required String refreshToken,
    required String expirationDate,
    required int expiresIn,
  }) = _Session;

  factory Session.fromJson(Map<String, Object?> json) =>
      _$SessionFromJson(json);

  factory Session.empty() => const _Session(
        email: '',
        userId: '',
        accessToken: '',
        refreshToken: '',
        expirationDate: '',
        expiresIn: 0,
      );

  static String tag = 'Session';
}
