import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app_kids/features/recommendation/cubit/recommendation_cubit.dart';

class AskMyParentsButton extends StatelessWidget {
  const AskMyParentsButton({required this.completed, super.key});
  final bool completed;
  @override
  Widget build(BuildContext context) {
    final String kidId = context.read<ProfilesCubit>().state.activeProfile.id;
    return ElevatedButton(
      onPressed: completed
          ? () {}
          : () => context.read<RecommendationCubit>().askMyParents(kidId),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            completed ? const Color(0xFF54A1EE) : const Color(0xFFF2DF7F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Text(
          completed ? 'Parents Notified! ✓' : 'Ask my parents',
          style: TextStyle(
            color: completed ? Colors.white : const Color(0xFF3B3240),
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
