import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:go_router/go_router.dart';

class AccountLockedDialog extends StatelessWidget {
  const AccountLockedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox(
        width: size.width * 0.8,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is! AccountLockedState) {
                  return Container();
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      SvgPicture.asset(
                          'assets/images/account_locked_dialog_image.svg'),
                      const SizedBox(height: 15),
                      Text(
                        'Oops!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.givt4KidsDarkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'We forget our login details from time to time as well.',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.givt4KidsDarkBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        state.minutesLeft > 0
                            ? 'Please try again in ${state.minutesLeft} minutes.'
                            : 'You can try again.',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.givt4KidsDarkBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'We sent you an email in case you want to reset your password.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.givt4KidsDarkGreyBlue,
                            ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: state.minutesLeft > 0
                              ? null
                              : () {
                                  // clear locked state
                                  context.read<AuthCubit>().logout();
                                  context.pop();
                                },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor: AppTheme.givt4KidsLightGreen,
                            foregroundColor: AppTheme.givt4KidsDarkGreen,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Sign in',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
