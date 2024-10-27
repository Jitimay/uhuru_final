import 'package:flutter/material.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/models/user_model.dart';

class PanelWidget extends StatelessWidget {
  const PanelWidget(
      {super.key,
      required this.user,
      required this.onClickedPanel,});
  final UserModel user;
  final VoidCallback onClickedPanel;

  @override
  Widget build(BuildContext context) => Column(
        children: [
         
          Expanded(
            child: Container(
             
              decoration:  BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: buildProfile(context),
            ),
          ),
        ],
      );

  Widget buildProfile(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClickedPanel,
        child: Stack(
          children: [
            Container(
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.only(left: 175, right: 175, top: 24),
            ),
            Align(
              alignment: Alignment.center,
                child: buildProfileDetails(user, context)
            ),
          ]
        ),
      );

  Widget buildProfileDetails(UserModel user, BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            user.name,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          Text(
            user.phoneNumber,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            '${Variables.bioString}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontStyle: FontStyle.normal),
          ),
        ],
      );
}
