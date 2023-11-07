import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app_kids/shared/widgets/givt_back_button.dart';
import 'package:givt_app_kids/shared/widgets/heading_2.dart';

class CameraQrHeader extends StatelessWidget {
  const CameraQrHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xFFEEEDE4),
        width: double.infinity,
        child: Row(
          children: [
            GivtBackButton(
              onPressedExt: () {
                context.read<FlowsCubit>().resetFlow();
              },
            ),
            const Expanded(
              child: Heading2(
                text: "Scan the Givt\nQR code",
                alignment: TextAlign.center,
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
    );
  }
}
