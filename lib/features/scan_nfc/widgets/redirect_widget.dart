import 'package:flutter/material.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:go_router/go_router.dart';

class RedirectPopWidget extends StatefulWidget {
  const RedirectPopWidget({super.key});

  @override
  State<RedirectPopWidget> createState() => _RedirectPopWidgetState();
}

class _RedirectPopWidgetState extends State<RedirectPopWidget> {
  @override
  void initState() {
    context.pop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () => context.goNamed(Pages.splash.name),
          child: Text('Go Home')),
    );
  }
}
