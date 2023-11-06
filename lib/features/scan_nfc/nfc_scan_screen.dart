import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/coin_found.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/coin_ready_animated_widget.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/search_coin_animated_widget.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/start_scan_nfc_button.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:go_router/go_router.dart';

class NFCScanPage extends StatelessWidget {
  const NFCScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanNfcCubit, ScanNfcState>(
      listener: (context, state) {
        final scanNfcCubit = context.read<ScanNfcCubit>();
        if (state.scanNFCStatus == ScanNFCStatus.scanning &&
            Platform.isAndroid) {
          log('SCANNING');
          showModalBottomSheet<void>(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (BuildContext context) {
              return BlocProvider.value(
                value: scanNfcCubit,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocBuilder<ScanNfcCubit, ScanNfcState>(
                    builder: (context, state) {
                      if (state.scanNFCStatus == ScanNFCStatus.scanned) {
                        return FoundNfcAnimation(scanNfcCubit: scanNfcCubit);
                      } else {
                        return ScanningNfcAnimation(scanNfcCubit: scanNfcCubit);
                      }
                    },
                  ),
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const GivtBackButton(),
          ),
          body: Center(
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text('Ready to make a difference?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                const Text('Grab your coin and \nlet\'s begin!',
                    style: TextStyle(fontSize: 16),
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
          ),
          floatingActionButton: state.scanNFCStatus == ScanNFCStatus.scanned
              ? StartScanNfcButton()
              : Platform.isIOS
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        // FETCH ORGANIZATION
                        context
                            .read<OrganisationDetailsCubit>()
                            .getOrganisationDetails(state.result);
                        context.pushReplacementNamed(
                            Pages.chooseAmountSliderCoin.name);
                      },
                      child: const Text(
                        'Choose an amount',
                        style: AppTheme.actionButtonStyle,
                      ),
                    )
                  : SizedBox(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

class ScanningNfcAnimation extends StatelessWidget {
  const ScanningNfcAnimation({required this.scanNfcCubit, super.key});
  final ScanNfcCubit scanNfcCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Ready to scan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        const Padding(
            padding: EdgeInsets.all(20), child: CoinReadyAnimatedWidget()),
        const Text('Tap your coin to the back\nof the screen',
            style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.maxFinite, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () {
            context.pop();
            scanNfcCubit.stopSimulation();
          },
          child: const Text(
            'Cancel',
            style: AppTheme.actionButtonStyle,
          ),
        )
      ],
    );
  }
}

class FoundNfcAnimation extends StatelessWidget {
  const FoundNfcAnimation({required this.scanNfcCubit, super.key});
  final ScanNfcCubit scanNfcCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Found it!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SvgPicture.asset('assets/images/mobile_found.svg'),
        ),
        const Text('Now let\'s select the amount',
            style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.maxFinite, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () {
            // FETCH ORGANIZATION
            context
                .read<OrganisationDetailsCubit>()
                .getOrganisationDetails(scanNfcCubit.state.result);
            context.pushReplacementNamed(Pages.chooseAmountSliderCoin.name);
          },
          child: const Text(
            'Choose an amount',
            style: AppTheme.actionButtonStyle,
          ),
        )
      ],
    );
  }
}
