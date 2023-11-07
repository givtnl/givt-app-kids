import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app_kids/features/recommendation/cubit/recommendation_cubit.dart';
import 'package:givt_app_kids/features/recommendation/widgets/ask_rec_button.dart';
import 'package:givt_app_kids/helpers/app_theme.dart';
import 'package:go_router/go_router.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.offWhite,
          toolbarHeight: 0,
        ),
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
            child: BlocBuilder<RecommendationCubit, RecommendationState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          padding: const EdgeInsets.all(0),
                          icon: SvgPicture.asset(
                            'assets/images/close_icon.svg',
                            height: 30,
                            width: 30,
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Text(
                      'Don’t know which \ncharity to give to?',
                      style: AppTheme.actionButtonStyle
                          .copyWith(color: AppTheme.defaultTextColor),
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
                    AskMyParentsButton(
                      completed: state is RecommendationSent,
                      sending: state is RecommendationSending,
                    ),
                    const SizedBox(height: 35)
                  ],
                );
              },
            ),
          ),
        ]));
  }
}
