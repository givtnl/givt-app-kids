import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app_kids/core/app/route_utils.dart';
import 'package:givt_app_kids/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/coin_founded.dart';
import 'package:givt_app_kids/features/coin_flow/widgets/search_coin_animated_widget.dart';
import 'package:givt_app_kids/shared/widgets/floating_animation_button.dart';
import 'package:go_router/go_router.dart';

class SearchForCoinScreen extends StatelessWidget {
  const SearchForCoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCoinCubit, SearchCoinState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFEEEDE4),
          body: state is SearchCoinAnimationState
              ? const SearchingForCoinPage()
              : const CoinFoundedPage(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state is SearchCoinFoundedState
              ? FloatingAnimationButton(
                  text: "Assign the coin",
                  onPressed: () {
                    context.pushNamed(Pages.profileSelectionCoin.name);
                  },
                )
              : null,
        );
      },
    );
  }
}

class SearchingForCoinPage extends StatelessWidget {
  const SearchingForCoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 150),
            child: Text(
              "Searching for the coin...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF3B3240),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: SearchCoinAnimatedWidget(),
          ),
        ),
      ],
    );
  }
}

class CoinFoundedPage extends StatelessWidget {
  const CoinFoundedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(left: 50, right: 50, top: 150),
            child: Column(
              children: [
                Text(
                  "Found it!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3B3240),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Let's assign the coin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3B3240),
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: SearchCoinAnimatedWidget(),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: CoinFounded(),
          ),
        ),
      ],
    );
  }
}
