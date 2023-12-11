import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/features/exhibition_flow/widgets/voucher_code_input.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/helpers/snack_bar_helper.dart';
import 'package:givt_app_kids/shared/widgets/floating_action_button.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';

class VoucherCodeScreen extends StatefulWidget {
  const VoucherCodeScreen({super.key});

  @override
  State<VoucherCodeScreen> createState() => _VoucherCodeScreenState();
}

class _VoucherCodeScreenState extends State<VoucherCodeScreen> {
  String _voucherCode = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ExternalErrorState) {
          SnackBarHelper.showMessage(
            context,
            text: 'Cannot login with voucher. Please try again later.',
            isError: true,
          );
        } else if (state is LoggedInState) {
          context.pushReplacementNamed(Pages.scanNFC.name);
          context.read<FlowsCubit>().startExhibitionFlow();
        }
      },
      builder: (context, state) => Scaffold(
        body: state is LoadingState
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
                            textStyle: Theme.of(context).textTheme.titleLarge,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.15),
                        VoucherCodeInput(
                          onChanged: (value) {
                            setState(() {
                              _voucherCode = value;
                            });
                          },
                        ),
                        SizedBox(height: size.height * 0.10),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: state is! LoadingState
            ? GivtFloatingActionButton(
                text: 'Start',
                onPressed: _voucherCode.length == AuthCubit.voucherCodeLength
                    ? () {
                        context
                            .read<AuthCubit>()
                            .loginByVoucherCode(_voucherCode);
                      }
                    : null,
              )
            : null,
      ),
    );
  }
}
