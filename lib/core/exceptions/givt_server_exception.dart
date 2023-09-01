import 'package:equatable/equatable.dart';

class GivtServerException extends Equatable implements Exception {
  const GivtServerException({
    required this.statusCode,
    this.body,
  });

  final int statusCode;
  final Map<String, dynamic>? body;

  @override
  List<Object?> get props => [statusCode, body];
}
