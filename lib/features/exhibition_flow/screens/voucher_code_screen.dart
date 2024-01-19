import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/exhibition_flow/widgets/voucher_code_input.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/profiles/models/profile.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

class VoucherCodeScreen extends StatefulWidget {
  const VoucherCodeScreen({super.key});

  @override
  State<VoucherCodeScreen> createState() => _VoucherCodeScreenState();
}

class _VoucherCodeScreenState extends State<VoucherCodeScreen> {
  String _voucherCode = '';

  void _updateVoucherCode(String code) {
    setState(() {
      _voucherCode = code;
    });
  }

  void _showErrorMessage() {
    SnackBarHelper.showMessage(
      context,
      text: 'Cannot login with voucher. Please try again later.',
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is ExternalErrorState) {
          _showErrorMessage();
        } else if (authState is LoggedInState) {
          context.read<ProfilesCubit>().fetchAllProfiles();
        }
      },
      builder: (context, authState) {
        return BlocConsumer<ProfilesCubit, ProfilesState>(
          listener: (context, propfilesState) {
            if (propfilesState is ProfilesExternalErrorState) {
              _showErrorMessage();
            } else if (propfilesState is ProfilesUpdatedState &&
                propfilesState.activeProfile == Profile.empty()) {
              context
                  .read<ProfilesCubit>()
                  .setActiveProfile(propfilesState.profiles[0].firstName);

              context.pushNamed(Pages.scanNFC.name);
            }
          },
          builder: (context, propfilesState) {
            return Scaffold(
              appBar: AppBar(
                leading: GivtBackButton(
                  onPressedExt: () => context.read<FlowsCubit>().resetFlow(),
                ),
              ),
              body: authState is LoadingState ||
                      propfilesState is ProfilesLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: SizedBox.expand(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: size.height * 0.1),
                              Text(
                                "Let's begin!",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Enter your unique Givt code',
                                style: GoogleFonts.mulish(
                                  textStyle:
                                      Theme.of(context).textTheme.titleLarge,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: size.height * 0.15),
                              VoucherCodeInput(
                                onChanged: _updateVoucherCode,
                              ),
                              SizedBox(height: size.height * 0.10),
                            ],
                          ),
                        ),
                      ),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: authState is! LoadingState &&
                      propfilesState is! ProfilesLoadingState
                  ? GivtElevatedButton(
                      text: 'Start',
                      isDisabled:
                          _voucherCode.length != AuthCubit.voucherCodeLength,
                      onTap: () {
                        context
                            .read<AuthCubit>()
                            .loginByVoucherCode(_voucherCode);
                        _updateVoucherCode('');
                      },
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
