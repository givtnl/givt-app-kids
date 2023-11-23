import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/coin_found.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/android_nfc_found_bottomsheet.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/android_nfc_scanning_bottomsheet.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/search_coin_animated_widget.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/start_scan_nfc_button.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
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
          showModalBottomSheet<void>(
            context: context,
            isDismissible: false,
            enableDrag: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (BuildContext context) {
              return BlocProvider.value(
                value: scanNfcCubit,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BlocBuilder<ScanNfcCubit, ScanNfcState>(
                    builder: (context, state) {
                      if (state.scanNFCStatus == ScanNFCStatus.scanned) {
                        return BlocBuilder<OrganisationDetailsCubit,
                            OrganisationDetailsState>(
                          builder: (context, state) {
                            return FoundNfcAnimation(
                              scanNfcCubit: scanNfcCubit,
                              isLoading: context
                                  .read<OrganisationDetailsCubit>()
                                  .state is OrganisationDetailsLoadingState,
                              onPressed: () => context.pushReplacementNamed(
                                Pages.chooseAmountSlider.name,
                              ),
                            );
                          },
                        );
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
        if (state.scanNFCStatus == ScanNFCStatus.scanned) {
          context
              .read<OrganisationDetailsCubit>()
              .getOrganisationDetails(state.mediumId);
          Future.delayed(ScanNfcCubit.foundDelay, () {
            context.pushReplacementNamed(Pages.chooseAmountSlider.name);
          });
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvent.inAppCoinScannedSuccessfully,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: GivtBackButton(
              onPressedExt: () {
                context.read<FlowsCubit>().resetFlow();
              },
            ),
          ),
          body: Center(
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                      state.coinAnimationStatus == CoinAnimationStatus.animating
                          ? 'Ready to make a difference?'
                          : 'Found it!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Text(
                    state.coinAnimationStatus == CoinAnimationStatus.animating
                        ? 'Grab your coin and \nlet\'s begin!'
                        : 'Let\'s continue...',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
                const Spacer(flex: 2),
                state.coinAnimationStatus == CoinAnimationStatus.animating
                    ? const SearchCoinAnimatedWidget()
                    : const CoinFound(),
                const SizedBox(height: 20),
                state.scanNFCStatus == ScanNFCStatus.error
                    ? const Text('Error scanning the coin')
                    : const Text(''),
                const Spacer(flex: 3),
              ],
            ),
          ),
          floatingActionButton: state.scanNFCStatus == ScanNFCStatus.cancelled
              ? const StartScanNfcButton()
              // on iOS user dismissing the bottomsheet cannot be detected
              // so we need to show the button always after the start of scanning
              : Platform.isIOS && state.scanNFCStatus == ScanNFCStatus.scanning
                  ? FutureBuilder(
                      future: Future.delayed(ScanNfcCubit.startDelay),
                      builder: (c, s) => const StartScanNfcButton())
                  : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
