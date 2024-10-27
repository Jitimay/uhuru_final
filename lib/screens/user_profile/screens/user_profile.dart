import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uhuru/common/utils/environment.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/models/user_model.dart';

import '../../auth/view/auth_screen.dart';
import '../widget/panel_widget.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});
  

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  List<UserModel> userModel= [];
  
  @override
  Widget build(BuildContext context) {
    userModel.add(UserModel(name: "${Variables.fullNameString}", uid: "${Variables.id}", profilePic: "${Variables.avatar}", isOnline: Variables.isActive, phoneNumber: "${Variables.phoneNumber}", groupId: []));
    final backgroundColor = Theme.of(context).colorScheme.background;
    final iconColor = Theme.of(context).colorScheme.onBackground;
    final panelController = PanelController();
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon:  Icon(Icons.person_outline,color: iconColor,),
          onPressed: () {
            setState(() {
              Variables.updateProfile = true;
            });
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => const UserInformation()));
          },
        ),
      ),
      body:
            SlidingUpPanel(
              maxHeight: 340,
              minHeight: 150,
              parallaxEnabled: true,
              parallaxOffset: 0.5,
              body: PageView(
                children: [
                  Variables.avatar!=null?
                  Image.network(
                    '${Environment.urlHost}${Variables.avatar}',
                    height: 10,
                    width: 10,
                  )
                  :Image.asset(
                    "assets/U1.png",
                    height: 10,
                    width: 10,
                  )
                  // CachedNetworkImage(
                  //   imageUrl: "${Variables.avatar}",
                  //   fit: BoxFit.cover,
                  // )
                ],
              ),
              panelBuilder: (ScrollController scrollController) => PanelWidget(
                user: userModel[0],
                onClickedPanel: panelController.open,
               
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            )
         
    );
  }
}
