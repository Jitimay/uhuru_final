// import 'package:flutter/material.dart';
// import 'package:uhuru/models/user_model.dart';
//
// import 'follow_button_widget.dart';
//
// class PanelHeaderWidget extends StatelessWidget {
//   const PanelHeaderWidget(
//       {super.key, required this.user,});
//   final UserModel user;
//
//   @override
//   Widget build(BuildContext context) => Row(
//         children: [
//           Expanded(child: buildUser(context)),
//           FollowButtonWidget(
//             userModel: user,
//           ),
//         ],
//       );
//
//   Widget buildUser(BuildContext context) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             user.name,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             user.phoneNumber,
//             style:
//                 Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 13),
//           ),
//         ],
//       );
// }
