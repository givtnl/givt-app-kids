class AuthRequest {
  AuthRequest({
    required this.email,
    required this.password,
    required this.type,
    required this.voucherCode,
  });

  AuthRequest.email({
    required this.email,
    required this.password,
  })  : type = LoginType.email,
        voucherCode = '';

  AuthRequest.voucher({
    required this.voucherCode,
  })  : type = LoginType.voucher,
        email = '',
        password = '';

  final String email;
  final String password;
  final LoginType type;
  final String voucherCode;
}

enum LoginType {
  email,
  voucher,
}
