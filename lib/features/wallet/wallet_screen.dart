import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/wallet_cubit.dart';

class WalletScreenCubit extends StatefulWidget {
  static const String routeName = "/wallet-cubit";

  const WalletScreenCubit({super.key});

  @override
  State<WalletScreenCubit> createState() => _WalletScreenCubitState();
}

class _WalletScreenCubitState extends State<WalletScreenCubit> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletCubit>(
      create: (context) => WalletCubit(),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<WalletCubit, WalletState>(
            builder: (context, state) {
              return Column(
                children: [
                  Spacer(),
                  Text('Wallet Screen'),
                  BlocBuilder<WalletCubit, WalletState>(
                    builder: (context, state) {
                      return Text('${state.walletValue}');
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<WalletCubit>().increment();
                        },
                        child: Text('Increment'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<WalletCubit>().decrememt();
                        },
                        child: Text('Decrement'),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
