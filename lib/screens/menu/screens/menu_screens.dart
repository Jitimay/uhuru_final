import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uhuru/screens/menu/screens/privacy_policy.dart';
import 'package:uhuru/screens/menu/screens/settings.dart';
import '../../user_profile/screens/user_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = Theme.of(context).colorScheme.background;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final iconColor = Theme.of(context).colorScheme.onBackground;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 3,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        child: Column(
          children: [
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [],
            // ),
            ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfile())),
              leading: Icon(
                Icons.person,
                color: iconColor,
              ),
              title: Text(
                AppLocalizations.of(context)!.account,
                style: textStyle,
              ),
            ),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const CreateGroupScreen(),
            //       ),
            //     );
            //   },
            //   leading: Icon(
            //     Icons.group,
            //     color: iconColor,
            //   ),
            //   title: Text(AppLocalizations.of(context)!.creategroup, style: textStyle),
            // ),
            // ListTile(
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //           builder: (context) => const NotificationScreen()),
            //     );
            //   },
            //   leading: b.Badge(
            //     position: b.BadgePosition.topEnd(),
            //     badgeStyle: b.BadgeStyle(badgeColor: backgroundColor),
            //     badgeContent: Text(
            //       "2",
            //       style: TextStyle(
            //           color: Colors.red,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16),
            //     ),
            //     child: const Icon(Icons.notifications),
            //   ),
            //   title: Text(translation(context).notification, style: textStyle),
            // ),
            // ListTile(
            //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => SavedVideo(
            //             index: 0,
            //           ))),
            //   leading: Icon(
            //     Icons.bookmark,
            //     color: iconColor,
            //   ),
            //   title: Text(
            //       "${translation(context).save} ${translation(context).video}",
            //       style: textStyle),
            // ),
            //
            // ListTile(
            //   onTap: () => Navigator.of(context).push(
            //       MaterialPageRoute(builder: (context) => const PubScreen())),
            //   leading: Icon(Icons.shopping_bag, color: iconColor),
            //   title: Text(translation(context).advertisement, style: textStyle),
            // ),
            ListTile(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen())), leading: Icon(Icons.settings, color: iconColor), title: Text(AppLocalizations.of(context)!.settings, style: textStyle)),
            ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicy(),
                ),
              ),
              leading: Icon(Icons.privacy_tip, color: iconColor),
              title: Text(
                  // "${translation(context).box} ${translation(context).off} ${translation(context).suggestions}",
                  AppLocalizations.of(context)!.privacypolicy,
                  style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
