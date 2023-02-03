// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import 'package:givt_app_kids/widgets/settings_drawer.dart';
// import 'package:givt_app_kids/models/goal.dart';
// import 'package:givt_app_kids/screens/success_screen.dart';
// import 'package:givt_app_kids/providers/wallet_provider.dart';

// class ChooseAmountScreen extends StatefulWidget {
//   static const String routeName = "/choose-ammount";

//   const ChooseAmountScreen({Key? key}) : super(key: key);

//   @override
//   _ChooseAmountScreenState createState() => _ChooseAmountScreenState();
// }

// class _ChooseAmountScreenState extends State<ChooseAmountScreen> {
//   final List<double> _amountOptions = [2, 5, 7];

//   int _currentAmmountIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     final goal = ModalRoute.of(context)?.settings.arguments as Goal;

//     var walletProvider = Provider.of<WalletProvider>(context);

//     return SafeArea(
//       child: Scaffold(
//         drawer: SettingsDrawer(),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding:
//                   EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 10),
//               child: Text(
//                 goal.name,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "In my wallet",
//                     style: TextStyle(
//                       fontSize: 22,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "\$${walletProvider.totalAmount.toStringAsFixed(2)}",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 29,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Choose amount you want to give",
//                     style: TextStyle(
//                       fontSize: 22,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: _createPickOptions(walletProvider),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               alignment: Alignment.center,
//               padding: EdgeInsets.only(bottom: 30),
//               child: ElevatedButton(
//                 onPressed: _currentAmmountIndex == -1
//                     ? null
//                     : () {
//                         var newAmount = walletProvider.totalAmount -
//                             _amountOptions[_currentAmmountIndex];
//                         if (newAmount < 0) {
//                           newAmount = 0;
//                         }
//                         walletProvider.setAmount(newAmount);

//                         Navigator.of(context).pushNamed(
//                           SuccessScreen.routeName,
//                           arguments: goal,
//                         );
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   child: Text(
//                     "GIVE NOW",
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

//   List<Widget> _createPickOptions(WalletProvider walletProvider) {
//     const double pickItemSize = 65;

//     List<Widget> result = [];

//     for (var i = 0; i < _amountOptions.length; i++) {
//       double currentOptionAmmount;

//       bool noMoreMoney = false;
//       if (walletProvider.totalAmount <= _amountOptions[i]) {
//         currentOptionAmmount = walletProvider.totalAmount;
//         noMoreMoney = true;
//       } else {
//         currentOptionAmmount = _amountOptions[i];
//       }

//       result.add(
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               if (_currentAmmountIndex == i) {
//                 _currentAmmountIndex = -1;
//               } else {
//                 _currentAmmountIndex = i;
//               }
//             });
//           },
//           child: Container(
//             margin: EdgeInsets.all(5),
//             alignment: Alignment.center,
//             width: pickItemSize,
//             height: pickItemSize,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Theme.of(context).primaryColor,
//               ),
//               borderRadius: BorderRadius.circular(10),
//               color: i == _currentAmmountIndex
//                   ? Theme.of(context).primaryColor
//                   : Colors.white,
//             ),
//             child: Text(
//               "\$${currentOptionAmmount.toStringAsFixed(0)}",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: i == _currentAmmountIndex
//                     ? Colors.white
//                     : Theme.of(context).primaryColor,
//               ),
//             ),
//           ),
//         ),
//       );
//       if (noMoreMoney) {
//         break;
//       }
//     }

//     return result;
//   }
// }
