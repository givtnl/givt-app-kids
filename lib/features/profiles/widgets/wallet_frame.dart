import 'package:flutter/material.dart';

class WalletFrame extends StatelessWidget {
  const WalletFrame(
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
