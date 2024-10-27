import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/screens/channels/channel_list_screen.dart';
import 'package:uhuru/screens/story/screens/status_contacts_screens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uhuru/screens/story/screens/story_widget.dart';
import 'package:uhuru/screens/uhuru_music/PAGES/homepage.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Updates',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => StatusContactScreens()));
            },
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.story),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChannelsScreen()));
            },
            child: ListTile(
              title: Text('Channels'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage()));
            },
            child: ListTile(
              title: Text('Uhuru music'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => StroryWidget(content: "Test", status: "Online",)));
            },
            child: ListTile(
              title: Text('Story widget '),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
            ),
          ),
        ],
      ),
      // body: SafeArea(
      //   child: DefaultTabController(
      //     length: 2,
      //     child: Column(
      //       children: [
      //         TabBar(
      //           indicatorColor: primaryColor,
      //           tabs: [
      //             Tab(text: 'Stories'),
      //             Tab(text: 'Channels'),
      //           ],
      //         ),
      //         Expanded(
      //           child: TabBarView(
      //             children: [
      //               // First Tab Content
      //               Container(
      //                 alignment: Alignment.center,
      //                 child: StatusContactScreens(),
      //               ),
      //               // Second Tab Content
      //               Container(
      //                 alignment: Alignment.center,
      //                 child: ChannelsScreen(),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
