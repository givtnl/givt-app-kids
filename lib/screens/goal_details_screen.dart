// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:givt_app_kids/screens/choose_amount_screen_v3.dart';

// import 'package:flutter_svg/svg.dart';

// import 'package:givt_app_kids/models/goal.dart';
// import 'package:givt_app_kids/widgets/settings_drawer.dart';
// import 'package:givt_app_kids/widgets/friends_donated_list.dart';

// class GoalDetailsScreen extends StatefulWidget {
//   static const String routeName = "/goal-details";

//   const GoalDetailsScreen({Key? key}) : super(key: key);

//   @override
//   State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
// }

// class _GoalDetailsScreenState extends State<GoalDetailsScreen> {

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final goal = ModalRoute.of(context)?.settings.arguments as Goal;

//     return SafeArea(
//       child: Scaffold(
//         drawer: SettingsDrawer(),
//         body: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage(goal.bgAsset),
//                 ),
//               ),
//               width: double.infinity,
//               height: 200,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 20,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             goal.name,
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 60,
//                           height: 60,
//                           child: SvgPicture.asset(
//                             goal.iconAsset,
//                             width: 60,
//                             height: 60,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     if(goal.friendsNum > 0) FriendsDonatedList(goal: goal),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       createDescriptionCard(context, "What we do", goal.what),
//                       createDescriptionCard(context, "Who we help", goal.who),
//                       createDescriptionCard(
//                           context, "How we use your giving", goal.how),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 bottom: 20,
//                 top: 5,
//               ),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pushNamed(
//                     ChooseAmountScreenV3.routeName,
//                     arguments: goal,
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   child: Text(
//                     "GIVE TO THIS GOAL",
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

//   Widget createDescriptionCard(
//     BuildContext context,
//     String title,
//     String description,
//   ) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       color: Colors.grey[200],
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               description,
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
