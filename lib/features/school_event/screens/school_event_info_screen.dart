import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/pages.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/shared/widgets/givt_elevated_button.dart';
import 'package:go_router/go_router.dart';

class SchoolEventInfoScreen extends StatelessWidget {
  const SchoolEventInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final activeProfile = context.watch<ProfilesCubit>().state.activeProfile;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.1),
              Text(
                "Hi ${activeProfile.firstName} family!\nHere is",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              Text(
                "\$${activeProfile.wallet.balance}",
                style: const TextStyle(fontSize: 77),
              ),
              const SizedBox(height: 30),
              Text(
                "to start\ngiving",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: size.height * 0.10),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GivtElevatedButton(
        text: 'Next',
        onTap: () => context.goNamed(Pages.wallet.name),
      ),
    );
  }
}
