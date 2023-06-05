import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';

class LoggedInTempScreen extends StatelessWidget {
  const LoggedInTempScreen({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LoggedInTempScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthCubit>().state as LoggedInState;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEDE4),
        body: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Logged in as:\n${state.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30),
              ),
              Text(
                'with token:\n${state.accessToken}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'LOGOUT',
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
