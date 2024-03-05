class AuthRequest {
  const AuthRequest({
    required this.email,
    required this.password,
    required this.type,
    required this.voucherCode,
    required this.familyName,
  });

  const AuthRequest.email({
    required this.email,
    required this.password,
  })  : type = LoginType.email,
        voucherCode = '',
        familyName = '';

  const AuthRequest.voucher({
    required this.voucherCode,
  })  : type = LoginType.voucher,
        email = '',
        password = '',
        familyName = '';

  const AuthRequest.family({
    required this.familyName,
  })  : type = LoginType.event,
        email = '',
        password = '',
        voucherCode = '';

  final String email;
  final String password;
  final LoginType type;
  final String voucherCode;
  final String familyName;
}

enum LoginType {
  email,
  voucher,
  event,
}
