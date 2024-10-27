import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/common/bloc/bloc/language_selecter_bloc.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uhuru/screens/menu/api/delete_account_api.dart';
import 'package:uhuru/screens/menu/utils/logout.dart';
import 'package:uhuru/services/fetching.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  dynamic saveThemeData;
  final _deleteAccountApi = Get.put(DeleteAccount());

  @override
  void initState() {
    super.initState();
    // getCurrentTheme();
  }

  // Future getCurrentTheme() async {
  //   saveThemeData = await AdaptiveTheme.getThemeMode();
  //   if (saveThemeData.toString() == "AdaptiveThemeMode.dark") {
  //     setState(() {
  //       Variables.isDarkMode = true;
  //     });
  //   } else {
  //     setState(() {
  //       Variables.isDarkMode = false;
  //     });
  //   }
  // }

  void toggleTheme() {
    setState(() {
      Variables.isDarkMode = !Variables.isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium;
    final iconColor = Theme.of(context).colorScheme.onBackground;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Icon(
              Icons.settings,
              color: iconColor,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              AppLocalizations.of(context)!.settings,
              style: textColor,
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Divider(
                  thickness: 0.4,
                  color: Colors.white,
                )),
            ListTile(
              onTap: () {
                // AdaptiveTheme.of(context).toggleThemeMode();
                toggleTheme();
                if (Variables.isDarkMode) {
                  AdaptiveTheme.of(context).setLight();
                  setDarkMode(false);
                } else {
                  AdaptiveTheme.of(context).setDark();
                  setDarkMode(true);
                }
              },
              contentPadding: const EdgeInsets.all(6),
              leading: Icon(
                Icons.remove_red_eye,
                color: iconColor,
              ),
              title: Text(
                AppLocalizations.of(context)!.mode,
                style: textColor,
              ),
              trailing: Icon(Variables.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Divider(
                  thickness: 0.4,
                  color: Colors.white,
                )),
            ListTile(
              iconColor: iconColor,
              contentPadding: const EdgeInsets.all(6),
              leading: const Icon(Icons.language),
              title: Text(
                AppLocalizations.of(context)!.language,
                style: textColor,
              ),
              trailing: DropdownButton<Locale>(
                iconSize: 30,
                underline: Text(''),
                items: L10nl.all.map<DropdownMenuItem<Locale>>((locale) {
                  final language = L10nl.getLanguage(locale.languageCode);
                  return DropdownMenuItem<Locale>(
                    value: locale,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (locale) async {
                  debugPrint(locale?.languageCode.toString());
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString("selectedLocale", locale?.languageCode ?? 'en');
                  context.read<LanguageSelecterBloc>().add(LanguageSelectedEvent(locale: locale!));
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: const Divider(
                thickness: 0.4,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  Variables.fullName.clear();
                  Variables.bio.clear();

                  Variables.avatar = null;
                  Variables.videoId = null;
                  Variables.storyList = [];

                  ///String
                  Variables.token = "";
                  Variables.countryName = "";
                  Variables.countryIso = "";
                  Variables.countryCode = "";
                  Variables.phoneNumber = "";
                  Variables.fullNameString = "";
                  Variables.bioString = "";

                  ///int
                  Variables.id = 0;
                  Variables.commentIndex = 0;

                  ///List
                  Variables.contacts = [];
                  Variables.videoList = [];
                  Variables.filteredVideos = [];
                  Variables.postedVideos = [];
                  Variables.ownStoryList = [];
                  Variables.friendsStoryList;
                  Variables.storyGroupedByPhone = [];
                  Variables.friendsGroupedByPhone = [];
                  Variables.videoCommentList = [];
                  Variables.groupedCommentList = [];
                  Variables.childCommentList = [];
                  Variables.storyViewList = [];
                });
                logout(context);
              },
              contentPadding: const EdgeInsets.all(6),
              leading: Icon(
                Icons.logout,
                color: iconColor,
              ),
              title: Text(
                // AppLocalizations.of(context)!.logout,
                'Logout',
                style: textColor,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: const Divider(
                thickness: 0.4,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                deleteVideo(Variables.phoneNumber);
              },
              contentPadding: const EdgeInsets.all(6),
              leading: Icon(
                Icons.delete_outline,
                color: iconColor,
              ),
              title: Text(
                // AppLocalizations.of(context)!.logout,
                'Delete account',
                style: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteVideo(phone) async {
    try {
      final response = await _deleteAccountApi.deleteAccountApi(phone, context);
      debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      if (response != null) {
        debugPrint('>>>>>>>>>>CURRENT RESPONSE!!$response!!<<<<<<<<<<<<');
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }
}
