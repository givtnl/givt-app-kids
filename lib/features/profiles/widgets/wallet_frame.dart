import 'package:flutter/material.dart';

class WalletFrame extends StatelessWidget {
  WalletFrame(
      {super.key,
      required this.body,
      required this.fab,
      required this.fabLocation});
  final Widget body;
  final Widget fab;
  final FloatingActionButtonLocation fabLocation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDE4),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.1),
          child: body,
        ),
      ),
      floatingActionButtonLocation: fabLocation,
      floatingActionButton: fab,
    );
  }
}
