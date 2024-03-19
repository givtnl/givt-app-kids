import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/android_nfc_found_bottomsheet.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/android_nfc_scanning_bottomsheet.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/search_coin_animated_widget.dart';
import 'package:givt_app_kids/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app_kids/features/scan_nfc/widgets/start_scan_nfc_button.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:go_router/go_router.dart';

import '../profiles/cubit/profiles_cubit.dart';

class NFCScanPage extends StatefulWidget {
  const NFCScanPage({super.key});

  @override
  State<NFCScanPage> createState() => _NFCScanPageState();
}

class _NFCScanPageState extends State<NFCScanPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScanNfcCubit>().readTag();
  }

  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;
    final user = context.read<ProfilesCubit>().state.activeProfile;
    final auth = context.read<AuthCubit>().state as LoggedInState;
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
                              onPressed: () {
                                if (auth.isSchoolEvenMode) {
                                  context.pushReplacementNamed(
                                      Pages.schoolEventOrganisations.name);
                                } else if (flow.isExhibition) {
                                  context.pushReplacementNamed(
                                      Pages.exhibitionOrganisations.name);
                                } else {
                                  context.pushReplacementNamed(
                                      Pages.chooseAmountSlider.name);
                                }
                              },
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
            if (auth.isSchoolEvenMode) {
              context.pushReplacementNamed(Pages.schoolEventOrganisations.name);
            } else if (flow.isExhibition) {
              context.pushReplacementNamed(Pages.exhibitionOrganisations.name);
            } else {
              context.pushReplacementNamed(Pages.chooseAmountSlider.name);
            }
          });
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvent.inAppCoinScannedSuccessfully,
            eventProperties: {
              AnalyticsHelper.mediumIdKey: state.mediumId,
            },
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
                context.read<ScanNfcCubit>().cancelScanning();

                if (context.read<FlowsCubit>().state.isExhibition) {
                  context.read<ProfilesCubit>().clearProfiles();
                  context.read<AuthCubit>().logout();
                }
              },
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text('Ready to make a difference?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  if (flow.isExhibition)
                    Text(
                      '\$${user.wallet.balance.toStringAsFixed(0)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.givt4KidsBlue,
                        fontSize: 32,
                      ),
                    ),
                  const Text('Grab your coin and \nlet\'s begin!',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),
                  const Spacer(flex: 2),
                  const SearchCoinAnimatedWidget(),
                  const SizedBox(height: 20),
                  state.scanNFCStatus == ScanNFCStatus.error
                      ? const Text('Error scanning the coin')
                      : const Text(''),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
          floatingActionButton: state.scanNFCStatus == ScanNFCStatus.ready
              ? const StartScanNfcButton()
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
