// ignore_for_file: must_be_immutable
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/screens/chats/bloc/chat_bloc.dart';
import 'package:uhuru/screens/chats/chats_screen.dart';
import 'package:uhuru/screens/group/bloc/group_bloc.dart';
import 'package:uhuru/screens/group/group_list_screen.dart';
import 'package:badges/badges.dart' as b;
import 'package:uhuru/screens/news/view/home_screen.dart';
import 'package:uhuru/screens/story/api/get_story.dart';
import 'package:uhuru/screens/updates/updates.dart';
import 'package:uhuru/services/connectivity.dart';

import '../../common/update_user_notif_key.dart';
import '../../common/utils/variables.dart';
import '../menu/screens/menu_screens.dart';
import '../story/model/group_status_by_phone_number.dart';
import '../story/screens/confirm_status_screen.dart';
import '../story/screens/status_contacts_screens.dart';
import '../video/views/screens/video_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  int? screenIndex;

  MobileLayoutScreen({Key? key, this.screenIndex}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  int bottomIconSize = 20;
  final _getStoryApi = Get.put(GetStory());
  bool isLoading = false;
  final _updateUserNotifKey = Get.put(UpdateNotificationKeyApi());

  Icon bottomIcon({required IconData? iconName, double size = 20, required Color? color}) {
    Icon icon;

    icon = Icon(
      iconName,
      size: size,
      color: color,
    );

    return icon;
  }

  Text label(String labelText) {
    Text text;
    text = Text(
      labelText,
      style: const TextStyle(fontSize: 20, color: Colors.white),
    );
    return text;
  }

  final List<Widget> _screens = [
    ///News
    const HomeScreen(),

    ///Video
    const VideoScreen(),

    ///Chats
    ChatsScreen(),

    GroupListScreen(),

    UpdatesScreen(),

    ///Story
    // const StatusContactScreens(),

    ///Menu
    const Menu(),
  ];
  int selectedIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    listenToConnectivityChanges();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 5, vsync: this);
    if(Variables.isOnline){
      updateUserNotifKey();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  updateUserNotifKey() async {
    var currentNotificationKey = await OneSignal.User.pushSubscription.id;
    debugPrint('>>>>>>>>>>UPDATING USER NOTIFICATION KEY $currentNotificationKey<<<<<<<<<<<<');
    try {
      final response = await _updateUserNotifKey.updateNotificationKeyApi('$currentNotificationKey');
      debugPrint('>>>>>>>>>>UPDATED $response<<<<<<<<<<<<');
    } catch (e) {
      debugPrint('**********UPDATE NOTIF KEY exception!!!!$e!!!!!!');
    }
  }

  getStory() async {
    try {
      setState(() {
        isLoading = false;
      });
      final response = await _getStoryApi.getStoryApi();
      debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      if (response != null) {
        setState(() {
          Variables.storyList = response;
          Variables.ownStoryList = response['owner_status'];
          Variables.friendsStoryList = response['friends_status'];
          Variables.storyGroupedByPhone = groupStatusesByPhoneNumbers(Variables.friendsStoryList);
          debugPrint('+++++++>>>>>>>>>>${Variables.storyGroupedByPhone}<<<<<<<<<<<<++++++');
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.hidden:
      // case AppLifecycleState.hidden:
      // TODO: Handle this case.

      // TODO: Handle this case.
    }
  }

  bool addStory = false;

  @override
  Widget build(BuildContext context) {
    // TimerService().startTimer((seconds) {
    //   context.read<GroupMessageStatusBloc>().add(GetGroupNewMessageEvent());
    // });
    final iconColor = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: MaterialStateProperty.all(Theme.of(context).iconTheme),
          // indicatorColor:    Colors.blue.shade100,
          indicatorColor: bottomNavIndicatorColor.withOpacity(.5),
          labelTextStyle: MaterialStateProperty.all(
            Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (value) {
            if (value == 4) {
              getStory();
              setState(() {
                selectedIndex = value;
                widget.screenIndex = value;
              });
            } else {
              setState(() {
                selectedIndex = value;
                widget.screenIndex = value;
              });
            }
          },
          animationDuration: const Duration(seconds: 2),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedIndex: widget.screenIndex ?? selectedIndex,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.newspaper_rounded),
              label: AppLocalizations.of(context)!.news,
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/lighteagle.svg',
                width: 40,
                height: 40,
                color: iconColor,
              ),
              label: 'Flying',
            ),
            NavigationDestination(
              icon: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is FetchingChatsState) {
                    if (state.chatsnewMessage > 0) {
                      return b.Badge(
                        badgeStyle: b.BadgeStyle(padding: EdgeInsets.all(5)),
                        badgeContent: Text(
                          state.chatsnewMessage > 0 ? state.chatsnewMessage.toString() : "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        child: const Icon(Icons.chat_bubble_outline_outlined),
                      );
                    } else {
                      return const Icon(Icons.chat_bubble_outline_outlined);
                    }
                  }
                  return const Icon(Icons.chat_bubble_outline_outlined);
                },
              ),
              label: AppLocalizations.of(context)!.chats,
            ),
            NavigationDestination(
              label: AppLocalizations.of(context)!.group,
              icon: BlocBuilder<GroupBloc, GroupState>(
                builder: (context, state) {
                  if (state is GroupFetchingState) {
                    if (state.groupWithNewMessage > 0) {
                      return b.Badge(
                          badgeContent: Text(
                            state.groupWithNewMessage > 0 ? state.groupWithNewMessage.toString() : "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          child: const Icon(Icons.group));
                    } else {
                      return const Icon(Icons.group);
                    }
                  }
                  return const Icon(Icons.group);
                },
              ),
            ),
            isLoading
                ? SpinKitCircle(
                    color: primaryColor,
                    size: 50.0,
                  )
                : NavigationDestination(
                    icon: const Icon(Icons.tips_and_updates_outlined),
                    label: 'Updates',
                  ),
            NavigationDestination(
              icon: Icon(Icons.menu),
              label: AppLocalizations.of(context)!.menu,
            ),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: _screens[widget.screenIndex ?? selectedIndex],
      ),
      floatingActionButton: selectedIndex == 4
          ? Container()
          // ? FloatingActionButton(
          //     onPressed: () async {
          //       // setState(() {
          //       //   addStory = !addStory;
          //       // });
          //       addStoryDialog(context);
          //     },
          //     backgroundColor: floatingBtnColor,
          //     child: Icon(
          //       Icons.add,
          //       color: primaryColor,
          //     ),
          //   )
          : Container(),
    );
  }

  void showMyDialog(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onBackground;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Story'),
          content: SizedBox(
            height: 150.0,
            child: Column(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        Variables.isVideo = false;
                        Variables.isImage = false;
                      });
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmStatusScreen()));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.draw_outlined,
                        color: iconColor,
                      ),
                      title: Text('Text'),
                    )),
                TextButton(
                    onPressed: () async {
                      // File? pickedImage = await pickImageFromGallery(context);
                      // debugPrint('------------${pickedImage?.path}-----------');
                      // if (pickedImage != null) {
                      //   // ignore: use_build_context_synchronously
                      //   Navigator.pop(context);
                      //   Navigator.pushNamed(context, ConfirmStatusScreen.routeName, arguments: pickedImage);
                      // }
                      final pickedFile = await FilePicker.platform.pickFiles(type: FileType.any);
                      // final pickedFile = await pickFile();
                      if (pickedFile != null) {
                        // Check if it's an image or video
                        setState(() {
                          Variables.isImage = pickedFile.files.single.path!.endsWith('.jpg') || pickedFile.files.single.path!.endsWith('.png');
                          Variables.isVideo = pickedFile.files.single.path!.endsWith('.mp4');
                        });

                        if (Variables.isImage) {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, ConfirmStatusScreen.routeName, arguments: pickedFile);
                        } else if (Variables.isVideo) {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, ConfirmStatusScreen.routeName, arguments: pickedFile);
                        } else {
                          // Show an error message if the selected file is not an image or video
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select an image or video'),
                            ),
                          );
                        }
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.perm_media_outlined,
                        color: iconColor,
                      ),
                      title: Text('Media'),
                    )),
              ],
            ),
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.pop(context); // Close the dialog
          //     },
          //     child: const Text('OK'),
          //   ),
          // ],
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path;
      final size = result.files.single.size;
    }
  }
}
