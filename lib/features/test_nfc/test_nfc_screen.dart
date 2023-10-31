import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/test_nfc/cubit/test_nfc_cubit.dart';

class TestNFCScanPage extends StatelessWidget {
  const TestNFCScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Test NFC'),
            SizedBox(height: 20),
            BlocBuilder<TestNfcCubit, TestNfcState>(
              builder: (context, state) {
                if (state is TestNfcScanning) {
                  return const CircularProgressIndicator();
                }
                if (state is TestNfcScanned) {
                  return Text(state.result);
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
