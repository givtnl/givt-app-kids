import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletFrame extends StatelessWidget {
  const WalletFrame({
    super.key,
    required this.body,
  });
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.width * 0.08, horizontal: size.width * 0.05),
          child: body,
        ),
      ),
    );
  }
}
