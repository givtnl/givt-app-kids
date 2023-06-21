import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/organisation/cubit/organisation_cubit.dart';

class MockSliderScreen extends StatelessWidget {
  const MockSliderScreen({super.key});
  static const String routeName = "/mock-slider";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganisationCubit, OrganisationState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Text(state.organisation.name),
          ),
        );
      },
    );
  }
}
