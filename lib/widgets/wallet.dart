// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import 'package:givt_app_kids/providers/profiles_provider.dart';

class Wallet extends StatelessWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profilesProvider = Provider.of<ProfilesProvider>(context);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              color: const Color(0xFF54A1EE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              )),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Text(
                    profilesProvider.activeProfile?.name ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "\$",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: profilesProvider.activeProfile != null
                              ? profilesProvider.activeProfile!.balance
                                  .toStringAsFixed(2)
                              : "",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 85),
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 2,
          child: SvgPicture.asset(
            height: 75,
            fit: BoxFit.fitHeight,
            "assets/images/wallet.svg",
          ),
        ),
      ],
    );
  }
}
