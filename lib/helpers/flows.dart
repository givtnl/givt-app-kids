import 'package:givt_app_kids/screens/goals_list_screen.dart';
import 'package:givt_app_kids/screens/goal_details_screen.dart';
import 'package:givt_app_kids/screens/choose_amount_screen.dart';
import 'package:givt_app_kids/screens/choose_amount_screen_v2.dart';
import 'package:givt_app_kids/screens/choose_amount_screen_v3.dart';

enum Flows {
  flow_1(
    name: "Flow with picker",
    routes: {
      GoalsListScreen.routeName: ChooseAmountScreen.routeName,
      GoalDetailsScreen.routeName: ChooseAmountScreen.routeName,
    },
  ),
  flow_2(
    name: "Flow with slider",
    routes: {
      GoalsListScreen.routeName: ChooseAmountScreenV2.routeName,
      GoalDetailsScreen.routeName: ChooseAmountScreenV2.routeName,
    },
  ),
  flow_3(
    name: "Donation flow",
    routes: {
      GoalDetailsScreen.routeName: ChooseAmountScreenV3.routeName,
    },
  );

  const Flows({required this.name, required this.routes});

  final String name;
  final Map<String, String> routes;
}
