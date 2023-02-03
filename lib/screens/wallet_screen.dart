// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
// import 'package:provider/provider.dart';

// import 'package:givt_app_kids/widgets/settings_drawer.dart';
// import 'package:givt_app_kids/screens/goals_list_screen.dart';
// import 'package:givt_app_kids/providers/wallet_provider.dart';

// class WalletScreen extends StatefulWidget {
//   static const String routeName = "/wallet";

//   const WalletScreen({Key? key}) : super(key: key);

//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {
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
//               child: ElevatedButton(
//                 onPressed: walletProvider.totalAmount > 0
//                     ? () {
//                         Navigator.of(context)
//                             .pushNamed(GoalsListScreen.routeName);
//                       }
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10),
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
