import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/features/recommendation/cubit/recommendation_cubit.dart';
import 'package:givt_app_kids/features/recommendation/widgets/ask_rec_button.dart';
import 'package:go_router/go_router.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/images/kids_rec_photo.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(5, 35, 5, 8),
                child: Text(
                  'Don’t know which \ncharity to give to?',
                  style: TextStyle(
                    color: Color(0xFF3B3240),
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Color(0xFF3B3240),
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(text: 'Try the '),
                    TextSpan(
                        text: 'Givt4Kids Charity Finder',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' on \nyour tablet or computer!'),
                  ],
                ),
              ),
              const Spacer(),
              BlocBuilder<RecommendationCubit, RecommendationState>(
                builder: (context, state) {
                  return AskMyParentsButton(
                      completed: state is RecommendationSent);
                },
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  'Skip this step',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 35)
            ],
          ),
        )
      ]),
    );
  }
}
