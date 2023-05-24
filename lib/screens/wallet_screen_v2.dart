// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
// import 'package:provider/provider.dart';
// import 'package:givt_app_kids/widgets/settings_drawer.dart';
// import 'package:givt_app_kids/screens/qr_code_scan_screen.dart';
// import 'package:givt_app_kids/providers/wallet_provider.dart';

// class WalletScreenV2 extends StatefulWidget {
//   static const String routeName = "/wallet-v2";

//   const WalletScreenV2({Key? key}) : super(key: key);

//   @override
//   State<WalletScreenV2> createState() => _WalletScreenV2State();
// }

// class _WalletScreenV2State extends State<WalletScreenV2> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

//   String _userName = SettingsDrawer.nameDefault;
//   int _userAge = SettingsDrawer.ageDefault;

//   @override
//   void initState() {
//     super.initState();
//     _readPreferences();
//   }

//   Future<void> _readPreferences() async {
//     var prefs = await StreamingSharedPreferences.instance;

//     if (!mounted) return;

//     var name = prefs.getString(
//       SettingsDrawer.nameKey,
//       defaultValue: SettingsDrawer.nameDefault,
//     );
//     name.listen((newName) {
//       if (!mounted) return;
//       setState(() {
//         _userName = newName;
//       });
//     });
//     var age = prefs.getInt(
//       SettingsDrawer.ageKey,
//       defaultValue: SettingsDrawer.ageDefault,
//     );
//     age.listen((newAge) {
//       if (!mounted) return;
//       setState(() {
//         _userAge = newAge;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var walletProvider = Provider.of<WalletProvider>(context);

//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         drawer: SettingsDrawer(),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.only(top: 50, bottom: 40),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor.withAlpha(38), //15%
//                 borderRadius: BorderRadius.vertical(
//                   bottom: Radius.circular(
//                     15,
//                   ),
//                 ),
//               ),
//               child: Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onLongPress: () =>
//                             _scaffoldKey.currentState!.openDrawer(),
//                         child: SvgPicture.asset(
//                           "assets/images/avatar.svg",
//                           width: 70,
//                           height: 70,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Text(
//                             _userName,
//                             style: TextStyle(
//                               fontSize: 27,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           Text(
//                             "$_userAge y.o.",
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Spacer(),
//                   ],
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 Text(
//                   "In my wallet",
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     style: TextStyle(
//                       fontSize: 55,
//                       color: Theme.of(context).primaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: "\$",
//                         style: TextStyle(
//                           fontSize: 35,
//                         ),
//                       ),
//                       TextSpan(
//                         text: walletProvider.totalAmount.toStringAsFixed(2),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: 30),
//               child: ElevatedButton.icon(
//                 onPressed: walletProvider.totalAmount > 0
//                     ? () {
//                         // Navigator.of(context)
//                         //     .pushNamed(GoalsListScreen.routeName);
//                         // Navigator.of(context).pushNamed(
//                         //   GoalDetailsScreen.routeName,
//                         //   arguments:
//                         //       Provider.of<GoalsProvider>(context, listen: false)
//                         //           .qrCodeFlowGoal,
//                         // );
//                         Navigator.of(context).pushNamed(
//                           QrCodeScanScreen.routeName,
//                         );
//                       }
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                 ),
//                 icon: Icon(
//                   Icons.qr_code_2,
//                   size: 45,
//                 ),
//                 label: Padding(
//                   padding: EdgeInsets.only(
//                     top: 10,
//                     bottom: 10,
//                     left: 5,
//                   ),
//                   child: Text(
//                     "I WANT TO GIVE",
//                     style: TextStyle(
//                       fontSize: 33,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
