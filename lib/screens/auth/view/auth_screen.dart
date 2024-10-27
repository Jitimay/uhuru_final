import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/common/utils/utils.dart';
import 'package:uhuru/screens/auth/model/auth_model.dart';
import 'package:uhuru/screens/call/key_center.dart';
import 'package:uhuru/screens/user_profile/api/update_profile_api.dart';
import 'package:uhuru/services/contacts.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../common/update_user_notif_key.dart';
import '../../../common/utils/environment.dart';
import '../../../common/utils/loader_dialog.dart';
import '../../home_screen/mobile_layout_screen.dart';
import '../../user_profile/api/profile_api.dart';
import '../../user_profile/model/user_info_saver.dart';
import '../api/auth_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserInformation extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformation({super.key});

  @override
  ConsumerState<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends ConsumerState<UserInformation> {
  final TextEditingController textEditingController = TextEditingController();
  final _profileApi = Get.put(ProfileApi());
  final _updateProfileApi = Get.put(UpdateProfileApi());
  final _updateUserNotifKey = Get.put(UpdateNotificationKeyApi());
  late SharedPreferences prefs;
  late String base64EncodedString;
  String _userAgent = '<unknown>';
  String _webUserAgent = '<unknown>';

  File? image;

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
    debugPrint('++++++++$image++++++++');
  }

  @override
  void initState() {
    super.initState();
    initUserAgentState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initUserAgentState() async {
    String userAgent, webViewUserAgent;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      await FlutterUserAgent.init();
      webViewUserAgent = FlutterUserAgent.webViewUserAgent!;
      debugPrint('''
applicationVersion => ${FlutterUserAgent.getProperty('applicationVersion')}
systemName         => ${FlutterUserAgent.getProperty('systemName')}
userAgent          => $userAgent
webViewUserAgent   => $webViewUserAgent
packageUserAgent   => ${FlutterUserAgent.getProperty('packageUserAgent')}
      ''');
    } on PlatformException {
      userAgent = webViewUserAgent = '<error>';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _userAgent = userAgent;
      _webUserAgent = webViewUserAgent;
    });
  }

  void storeUserData() async {
    debugPrint('UPDATE PROFILE********${Variables.updateProfile}******');
    String name = Variables.fullName.text.trim();
    if (name.isNotEmpty) {
      var status = await OneSignal.User.pushSubscription.id;
      // String oneSignalTokenId = status.getOnesignalId() as String;
      print('*************************USERID__________$status');
      debugPrint('******name if statement*****->${Variables.fullName.text}, ${Variables.bio.text}, ${image}, ${Variables.countryName}, ${Variables.countryCode},${Variables.countryIso}, ${Variables.phoneNumber}, $status');
      debugPrint('PROFILE UPDATE#############>${Variables.updateProfile}');
      if (Variables.updateProfile) {
        if (image != null) {
          List<int> imageBytes = image!.readAsBytesSync();
          final base64img = base64Encode(imageBytes);
          debugPrint('BASE64********$base64img******');
          String decodedAvatar = base64Decode(base64img).toString();
          await updateProfile(Variables.bio.text, image!.path, Variables.fullName.text);
        } else {
          updateProfile(Variables.bio.text, "$image", Variables.fullName.text);
        }
      } else {
        final response = await AuthApi().authentication(
          Variables.phoneNumber,
          Variables.fullName.text,
          Variables.bio.text,
          image,
          Variables.countryCode,
          Variables.countryName,
          Variables.countryIso,
          "${Variables.phoneNumber}$_userAgent",
          context,
        );
        if (response.status != 0) {
          setState(() {
            Variables.signIn = false;
            Variables.signUp = false;
            Variables.updateProfile = false;
          });
          await getProfile();
        } else {
          setState(() {
            Variables.signIn = false;
            Variables.signUp = false;
            Variables.updateProfile = false;
          });
          Navigator.of(context, rootNavigator: true).pop();
          showSnackBar(content: response.message, context: context);
        }
      }
    } else {
      showSnackBar(content: "remplie tous les champs", context: context);
    }
  }

  getProfile() async {
    prefs = await SharedPreferences.getInstance();
    try {
      final response = await _profileApi.profileApi();
      debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      await UserInfoSaver().infoSaver(response['id'], response['avatar'], response['full_name'], response['bio'], response['is_active'], response['date_joined']);
      if (response['id'] != null) {
        setState(() {
          Variables.id = prefs.getInt('id')!;
          Variables.avatar = prefs.getString('avatar');
          Variables.fullNameString = prefs.getString('full_name')!;
          Variables.bioString = prefs.getString('bio')!;
          Variables.isActive = prefs.getBool('is_active')!;
          Variables.dateJoined = prefs.getString('date_joined')!;
        });
        debugPrint('>>>>>>>>>>${Variables.id}<<<<<<<<<<<<');
        debugPrint('>>>>>>>>>>${Variables.fullNameString}<<<<<<<<<<<<');
        Navigator.of(context)
            .push(
              MaterialPageRoute(builder: (context) => MobileLayoutScreen()),
            )
            .then((_) => Navigator.of(context).popUntil((route) => route.isFirst));
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

  Future<void> zegoLogin({id, userName}) async {
    await ZIMKit().connectUser(id: id, name: userName);
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: id,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],

      // Modify your custom configurations here.
      ringtoneConfig: ZegoCallRingtoneConfig(
        incomingCallPath: "assets/ringtone/incomingCallRingtone.mp3",
        outgoingCallPath: "assets/ringtone/outgoingCallRingtone.mp3",
      ),
      requireConfig: (ZegoCallInvitationData data) {
        var config = (data.invitees.length > 1)
            ? ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        /// show minimizing button
        config.topMenuBar.isVisible = true;
        config.topMenuBar.buttons.insert(0, ZegoCallMenuBarButtonName.minimizingButton);

        return config;
      },
    );

    // await ZegoUIKitPrebuiltCallInvitationService()
    //     .send(invitees: invitees, isVideoCall: isVideoCall);
    // debugPrint('Connected to zego $rsp');
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

  updateProfile(String bio, String avatar, String full_name) async {
    LoaderDialog.showLoader(context!, Variables.keyLoader);
    debugPrint('>>>>>>>>>>UPDATE FUNCTION<<<<<<<<<<<<');
    await updateUserNotifKey();
    try {
      final response = await _updateProfileApi.updateProfileApi(bio, avatar, full_name, context);
      debugPrint('>>>>>>>>>>CACIYEMWO<<<<<<<<<<<<');
      if (response?['full_name'] != null) {
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
        setState(() {
          Variables.avatar = response?['avatar'];
          Variables.fullNameString = response!['full_name']!;
          Variables.fullName.text = response['full_name']!;
          Variables.bioString = response['bio']!;
          Variables.bio.text = response['bio']!;
        });
        await getProfile();
      } else {
        debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      debugPrint('**********This is the exception!!!!$e!!!!!!');
      if (avatar == "null") {
        showSnackBar(content: "Kindly add a picture", context: context);
      } else {
        showSnackBar(content: "$e", context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? Variables.updateProfile && Variables.avatar != null
                          ? CircleAvatar(
                              backgroundImage: AssetImage("assets/backgroundImage.png"),
                              // NetworkImage(
                              //     '${Environment.urlHost}${Variables.avatar}'),
                              radius: 45,
                            )
                          : const CircleAvatar(
                              backgroundImage: AssetImage("assets/backgroundImage.png"),
                              radius: 45,
                            )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 45,
                        ),
                  Positioned(bottom: -10, right: 0, child: IconButton(onPressed: selectImage, icon: const Icon(Icons.add_a_photo)))
                ],
              ),
              Container(
                width: size.width * 1.00,
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: Variables.fullName,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enteryourfullname,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: Variables.bio,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enteryourbio,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (await Permission.contacts.request().isGranted && await Permission.notification.request().isGranted && await Permission.microphone.request().isGranted && await Permission.camera.request().isGranted) {
                          storeUserData();
                          await phoneNumbersFilter();
                          // await zegoLogin();
                        }
                      },
                      icon: const Icon(Icons.done))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
