// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

import 'package:givt_app_kids/providers/profiles_provider.dart';
import 'package:givt_app_kids/models/profile.dart';
import 'package:givt_app_kids/helpers/analytics_helper.dart';

class ProfileSelectionOverlayScreen extends StatefulWidget {
  static const String routeName = "/profile-selection-overlay";

  const ProfileSelectionOverlayScreen({Key? key}) : super(key: key);

  @override
  _ProfileSelectionOverlayScreenState createState() =>
      _ProfileSelectionOverlayScreenState();
}

class _ProfileSelectionOverlayScreenState
    extends State<ProfileSelectionOverlayScreen> {
  bool _isLoading = false;

  Future<void> _selectProfile(Profile profile) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ProfilesProvider>(context, listen: false)
        .setActiveProfile(profile);
    await AnalyticsHelper.logButtonPressedEvent(
      "Profile [${profile.name}] selected",
      ProfileSelectionOverlayScreen.routeName,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var profilesProvider = Provider.of<ProfilesProvider>(context);

    List<Profile> list = [];
    list.add(profilesProvider.activeProfile!);
    for (var i = 0; i < profilesProvider.profiles.length; i++) {
      if (profilesProvider.profiles[i].guid ==
          profilesProvider.activeProfile!.guid) {
        continue;
      }
      list.add(profilesProvider.profiles[i]);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(204, 59, 50, 64),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF54A1EE),
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topRight,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: list.map((profile) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: GestureDetector(
                          onTap: () {
                            _selectProfile(profile);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: profile.monster.color,
                                ),
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  profile.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SvgPicture.asset(
                                  profile.monster.image,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
