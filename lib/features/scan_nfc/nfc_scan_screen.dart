import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/coin_found.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/search_coin_animated_widget.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/start_scan_nfc_button.dart';
import 'package:givt_app_kids/shared/widgets/back_button.dart' as shared;

class NFCScanPage extends StatelessWidget {
  const NFCScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const shared.BackButton(),
      ),
      body: BlocBuilder<ScanNfcCubit, ScanNfcState>(
        builder: (context, state) {
          return Center(
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text('Ready to make a difference?',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('Grab your coin and \nlet\'s begin!',
                    textAlign: TextAlign.center),
                const Spacer(flex: 2),
                state.coinAnimationStatus == CoinAnimationStatus.animating
                    ? const SearchCoinAnimatedWidget()
                    : const CoinFound(),
                const SizedBox(height: 20),
                state.scanNFCStatus == ScanNFCStatus.scanning
                    ? const Text('Scanning the coin...')
                    : state.scanNFCStatus == ScanNFCStatus.scanned
                        ? Text("Coin's data: ${state.result}")
                        : state.scanNFCStatus == ScanNFCStatus.error
                            ? const Text('Error scanning the coin')
                            : const Text(''),
                const Spacer(flex: 3),
              ],
            ),
          );
        },
      ),
      floatingActionButton: const StartScanNfcButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
