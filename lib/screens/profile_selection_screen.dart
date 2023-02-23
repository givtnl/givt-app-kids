// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/providers/profiles_provider.dart';
import 'package:givt_app_kids/widgets/profile_item.dart';
import 'package:givt_app_kids/models/profile.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class ProfileSelectionScreen extends StatefulWidget {
  static const String routeName = "/profile-selection";

  const ProfileSelectionScreen({Key? key}) : super(key: key);

  @override
  _ProfileSelectionScreenState createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ProfilesProvider>(context, listen: false)
          .fetchProfiles();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot download profiles. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectProfile(Profile selectedProfile) async {
    await Provider.of<ProfilesProvider>(context, listen: false)
        .setActiveProfile(selectedProfile);
    await AnalyticsHelper.logButtonPressedEvent(
      "Profile [${selectedProfile.name}] selected",
      ProfileSelectionScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    var profilesProvider = Provider.of<ProfilesProvider>(context);
    List<Widget> gridItems = [];
    for (var i = 0, j = 0; i < profilesProvider.profiles.length; i++, j++) {
      gridItems.add(
        GestureDetector(
          onTap: () {
            _selectProfile(profilesProvider.profiles[i]);
          },
          child: ProfileItem(profilesProvider.profiles[i].name,
              profilesProvider.profiles[i].monster.image),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEDE4),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF54A1EE),
                ),
              )
            : profilesProvider.profiles.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "There is no profiles attached to the current user.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF54A1EE),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _fetchProfiles(),
                            icon: Icon(Icons.refresh_rounded),
                            label: Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(50),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              "Choose your profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF54A1EE),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: gridItems.length == 1 ? 1 : 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              children: gridItems,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
