import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/screens/auth/view/number_input_screen.dart';
import 'package:uhuru/screens/auth/view/landing_screen.dart';
import 'package:uhuru/screens/home_screen/mobile_layout_screen.dart';
import 'package:uhuru/screens/splashscreen/model/account_verification_model.dart';
import 'package:uhuru/screens/user_profile/api/profile_api.dart';
import 'package:uhuru/screens/user_profile/model/user_info_saver.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../common/utils/variables.dart';
import '../call/key_center.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late SharedPreferences prefs;
  final _accountVerificationModel = Get.put(AccountVerificationModel());
  final _profileApi = Get.put(ProfileApi());
  String _userAgent = '<unknown>';
  String _webUserAgent = '<unknown>';

  @override
  void initState() {
    super.initState();
    initFunctions();
  }

  Future<void> initFunctions() async {
    await initUserAgentState();
    await Future.delayed(const Duration(seconds: 0)).then((value) async {
      try {
        prefs = await SharedPreferences.getInstance();
        if (prefs.getString('phonenumber') != null) {
          setState(() {
            Variables.phoneNumber = prefs.getString('phonenumber')!;
            Variables.id = prefs.getInt('id')!;
            Variables.avatar = prefs.getString('avatar');
            Variables.fullNameString = prefs.getString('full_name')!;
            Variables.fullName.text = prefs.getString('full_name')!;
            Variables.bioString = prefs.getString('bio')!;
            Variables.bio.text = prefs.getString('bio')!;
            Variables.isActive = prefs.getBool('is_active')!;
            Variables.dateJoined = prefs.getString('date_joined')!;
            Variables.token = prefs.getString('token')!;
          });
          debugPrint('==========${Variables.phoneNumber}$_userAgent============');
          // updateUserNotifKey();
          debugPrint('>>>>>>>>>>${Variables.id}<<<<<<<<<<<<');
          debugPrint('>>>>>>>>>>${Variables.fullNameString}<<<<<<<<<<<<');
          debugPrint('>>>>>>>>>>${Variables.phoneNumber}<<<<<<<<<<<<');
          debugPrint('>>>>>>>>>>${Variables.avatar}<<<<<<<<<<<<');
          debugPrint('>>>>>>>>>>${Variables.fullName.text}<<<<<<<<<<<<');
          debugPrint('>>>>>>>>>>${Variables.bioString}<<<<<<<<<<<<');
          debugPrint('>>>>>>>>>>${Variables.bio.text}<<<<<<<<<<<<');
          debugPrint('>>>>>>>>>>${Variables.isActive}<<<<<<<<<<<<');
          debugPrint('>>>>>>>>>>${Variables.dateJoined}<<<<<<<<<<<<');
          debugPrint('>>>>>>>>>>${Variables.token}<<<<<<<<<<<<');
          if (Variables.isOnline) {
            await zegoLogin(
              id: Variables.phoneNumber,
              userName: Variables.fullNameString,
            );
          }
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MobileLayoutScreen()));
          // await accountVerification(Variables.phoneNumber, "${Variables.phoneNumber}$_userAgent");
        } else {
          debugPrint('-*****NO TOKEN CREATED*****-');
          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const LandingScreen()));
        }
      } on FlutterError {
        debugPrint("hello");
      }
    });
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

  ///This will save a new token received after login
  tokenSaver(token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  ///This will verify the current PhoneNumber for account access
  accountVerification(phoneNumber, password) async {
    prefs = await SharedPreferences.getInstance();
    try {
      final response = await _accountVerificationModel.accountVerificationModel(phoneNumber, password);
      if (response['access'] != null) {
        debugPrint('-*****ACCOUNT VERIFIED*****->$response');
        await tokenSaver(response['access']);
        setState(() {
          Variables.token = prefs.getString('token')!;
        });
        debugPrint('-*****NEW TOKEN*****->${Variables.token}');
        await getProfile();
      } else {
        debugPrint('-*****NO TOKEN CREATED*****->$response');
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => const LandingScreen()));
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
      if (Variables.dioResponseExceptionData != null && Variables.dioResponseExceptionData['detail'] == 'No active account found with the given credentials') {
        debugPrint('-*****NO TOKEN CREATED*****->YOU WILL HAVE TO SIGNUP WITH THE DISPLAYED SCREEN');
        setState(() {
          Variables.signUp = true;
          Variables.signIn = false;
          Variables.updateProfile = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LandingScreen()));
      }
    }
  }

  Future<void> zegoLogin({id, userName}) async {
    debugPrint('Zego Hel00*************');
    final rsp = await ZIMKit().connectUser(id: id, name: userName);
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: id,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
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

      // uiConfig: ZegoCallInvitationUIConfig(
      //   acceptButton: ZegoCallButtonUIConfig(icon: Icon(Icons.phone)),
      //   declineButton: ZegoCallButtonUIConfig(icon: Icon(Icons.call_end)),
      // ),
      // notificationConfig: ZegoCallInvitationNotificationConfig(
      //   androidNotificationConfig: ZegoCallAndroidNotificationConfig(
      //     sound: "zego_incoming",
      //   ),
      // ),
    );

    // await ZegoUIKitPrebuiltCallInvitationService()
    //     .send(invitees: invitees, isVideoCall: isVideoCall);
    // debugPrint('Connected to zego $rsp');
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
          Variables.fullName.text = prefs.getString('full_name')!;
          Variables.bioString = prefs.getString('bio')!;
          Variables.bio.text = prefs.getString('bio')!;
          Variables.isActive = prefs.getBool('is_active')!;
          Variables.dateJoined = prefs.getString('date_joined')!;
        });
        debugPrint('>>>>>>>>>>${Variables.id}<<<<<<<<<<<<');
        debugPrint('>>>>>>>>>>${Variables.fullNameString}<<<<<<<<<<<<');
        await zegoLogin(
          id: Variables.phoneNumber,
          userName: Variables.fullNameString,
        );

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MobileLayoutScreen()));
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!!$e!!!!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/U1.png"),
              width: 200,
            ),
            SpinKitThreeBounce(
              color: Colors.cyan[900],
              size: 50.0,
            ),
            SizedBox(
              height: 17,
            ),
            Text(
              "Uhuru",
              style: TextStyle(
                color: Colors.cyan[900],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
