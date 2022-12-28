import 'package:flutter/material.dart';
import 'package:givt_app_kids/helpers/flows.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:givt_app_kids/widgets/settings_drawer.dart';
import 'package:givt_app_kids/screens/wallet_screen.dart';
import 'package:givt_app_kids/screens/wallet_screen_v2.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFlowIndex = SettingsDrawer.selectedFlowDefault;

  Future<void> _checkDefaultValues(StreamingSharedPreferences prefs) async {
    var keys = prefs.getKeys().getValue();
    if (!keys.contains(SettingsDrawer.nameKey)) {
      await prefs.setString(SettingsDrawer.nameKey, SettingsDrawer.nameDefault);
    }
    if (!keys.contains(SettingsDrawer.ageKey)) {
      await prefs.setInt(SettingsDrawer.ageKey, SettingsDrawer.ageDefault);
    }
    if (!keys.contains(SettingsDrawer.walletKey)) {
      await prefs.setDouble(
          SettingsDrawer.walletKey, SettingsDrawer.walletAmountDefault);
    }
    if (!keys.contains(SettingsDrawer.flowKey)) {
      await prefs.setInt(
          SettingsDrawer.flowKey, SettingsDrawer.selectedFlowDefault);
    }
  }

  Future<String> _readPreferences() async {
    var prefs = await StreamingSharedPreferences.instance;
    await _checkDefaultValues(prefs);

    var flowIndex = prefs.getInt(SettingsDrawer.flowKey,
        defaultValue: SettingsDrawer.selectedFlowDefault);
    int selectedFlowIndex = flowIndex.getValue();
    Flows selectedFlow = Flows.values[selectedFlowIndex];

    String nextRoute;
    switch (selectedFlow) {
      case Flows.flow_3:
        nextRoute = WalletScreenV2.routeName;
        break;
      case Flows.flow_1:
      case Flows.flow_2:
      default:
        nextRoute = WalletScreen.routeName;
    }
    return nextRoute;
  }

  @override
  void initState() {
    super.initState();
    _readPreferences().then((nextRoute) => Navigator.of(context).pushNamed(nextRoute));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
    );
  }
}
