import 'package:flutter/material.dart';
import 'package:givt_app_kids/helpers/flows.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/providers/goals_provider.dart';
import 'package:givt_app_kids/widgets/goal_list_item.dart';

class GoalsListScreen extends StatefulWidget {
  static const String routeName = "/goals-list";

  const GoalsListScreen({Key? key}) : super(key: key);

  @override
  State<GoalsListScreen> createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  Flows _currentFlow = Flows.flow_1;

  @override
  void initState() {
    super.initState();
    _readPreferences();
  }

  Future<void> _readPreferences() async {
    var prefs = await StreamingSharedPreferences.instance;
    var flow = prefs.getInt(SettingsDrawer.flowKey, defaultValue: 0);
    setState(() {
      _currentFlow = Flows.values[flow.getValue()];
    });
  }

  @override
  Widget build(BuildContext context) {
    var goals = Provider.of<GoalsProvider>(context, listen: false).goals;

    return SafeArea(
      child: Scaffold(
        drawer: SettingsDrawer(),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40, left: 20, bottom: 20),
                  child: Text(
                    "My Goals",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Column(
                  children: goals.map((goal) {
                    return GoalListItem(
                      goal: goal,
                      currentFlow: _currentFlow,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
