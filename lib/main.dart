import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:isar/isar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/common/bloc/bloc/language_selecter_bloc.dart';
import 'package:uhuru/common/update_user_notif_key.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/router.dart';
import 'package:uhuru/screens/auth/view/landing_screen.dart';
import 'package:uhuru/screens/call/key_center.dart';
import 'package:uhuru/screens/channels/apis/channel_apis.dart';
import 'package:uhuru/screens/channels/blocs/channel/channel_bloc.dart';
import 'package:uhuru/screens/channels/blocs/channel_message/channel_message_bloc.dart';
import 'package:uhuru/screens/chats/bloc/chat_bloc.dart';
import 'package:uhuru/screens/chats/model/chat_model.dart';
import 'package:uhuru/screens/group/bloc/group_bloc.dart';
import 'package:uhuru/screens/group/data/model/group_model.dart';
import 'package:uhuru/screens/group/data/model/participant_model.dart';
import 'package:uhuru/screens/home_screen/mobile_layout_screen.dart';
import 'package:uhuru/screens/messages/bloc/message_bloc.dart';
import 'package:uhuru/screens/messages/data/model/message_model.dart';
import 'package:uhuru/screens/splashscreen/model/account_verification_model.dart';
import 'package:uhuru/screens/splashscreen/splash_screen.dart';
import 'package:uhuru/screens/user_profile/api/profile_api.dart';
import 'package:uhuru/services/connectivity.dart';
import 'package:uhuru/services/fetching.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'common/utils/environment.dart';
import 'firebase_options.dart';
import 'screens/group/bloc/participants/participants_bloc.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initConnectivity();
  listenToConnectivityChanges();
  if (Variables.isOnline) {
    ///Zego Needs internet
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(_navigatorKey);
    ZIMKit().init(
      appID: appID,
      appSign: appSign,
    );

    ///Zego Needs internet
    ZegoUIKit().initLog().then((value) {
      ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
        [ZegoUIKitSignalingPlugin()],
      );
    });

    ///Firebase & OneSignal & Mobile Needs internet
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await dotenv.load(fileName: Environment.fileName!);
  final dir = await getApplicationDocumentsDirectory();

  await Isar.open(
    [
      ChatModelSchema,
      MessageModelSchema,
      GroupModelSchema,
      ParticipantModelSchema,
    ],
    directory: dir.path,
    inspector: true,
  );

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // OneSignal.initialize("139c014b-5498-4e8b-9ca2-8261caa19591");
  OneSignal.Notifications.requestPermission(true);

  MobileAds.instance.initialize();
  runApp(
    ProviderScope(child: MyApp(navigatorKey: _navigatorKey)),
  );
}

Timer? _timer;

///StartTimer Needs Internet
void _startTimer(context) async {
  stopTimer();
  _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
    if (Variables.isOnline) {
      if (Variables.token.isNotEmpty) {
        await fetchChats(context);
        await fetchGroups(context: context);
      }
    }
  });
}

void stopTimer() {
  _timer?.cancel();
  _timer = null;
}

class MyApp extends StatefulWidget {
  final navigatorKey;

  const MyApp({
    Key? key,
    this.navigatorKey,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences prefs;
  final _accountVerificationModel = Get.put(AccountVerificationModel());
  final _profileApi = Get.put(ProfileApi());
  final _updateUserNotifKey = Get.put(UpdateNotificationKeyApi());
  String _userAgent = '<unknown>';
  String _webUserAgent = '<unknown>';

  @override
  void initState() {
    super.initState();
    // initConnectivity();
    connectivitySubscription();
    listenToConnectivityChanges();
    if (Variables.isOnline) {
      configOneSignal();
    }
    initFunctions(widget.navigatorKey);
  }

  Future<void> configOneSignal() async {
    OneSignal.initialize("${Variables.appId}");
    // .shared.init('139c014b-5498-4e8b-9ca2-8261caa19591');

    var status = await OneSignal.User.pushSubscription.id;
    // String oneSignalTokenId = status.getOnesignalId() as String;
    print('*************************NOTIFICATION KEY__________$status');
  }

  Future<void> initFunctions(GlobalKey<NavigatorState> navigatorKey) async {
    await initUserAgentState();

    await Future.delayed(const Duration(seconds: 0)).then((value) async {
      try {
        prefs = await SharedPreferences.getInstance();
        if (prefs.getString('phonenumber') != null) {
          setState(() {
            Variables.phoneNumber = prefs.getString('phonenumber')!;
            Variables.token = prefs.getString('token')!;
          });
          debugPrint('-*****NEW TOKEN*****->${Variables.token}');
          // await updateUserNotifKey();
          debugPrint('==========${Variables.phoneNumber}$_userAgent============BIRAHEZE');
          await accountVerification(Variables.phoneNumber, "${Variables.phoneNumber}$_userAgent");
        } else {
          FlutterNativeSplash.remove();
          debugPrint('-*****NO TOKEN CREATED*****-');
          if (Variables.isOnline) {
            await updateUserNotifKey();
          }
          navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => const LandingScreen()));
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
      // final response = await _accountVerificationModel.accountVerificationModel(phoneNumber, password);
      if (Variables.token != '') {
        // debugPrint('-*****ACCOUNT VERIFIED*****->$response');
        // await tokenSaver(response['access']);
        // setState(() {
        //   Variables.token = prefs.getString('token')!;
        // });
        debugPrint('-*****NEW TOKEN*****->${Variables.token}');
        if (Variables.isOnline) {
          await updateUserNotifKey();
        }
        await getProfile();
      } else {
        FlutterNativeSplash.remove();
        // debugPrint('-*****NO TOKEN CREATED*****->$response');
        debugPrint('-*****NO TOKEN CREATED*****->');
        widget.navigatorKey.pushReplacement(MaterialPageRoute(builder: (context) => const LandingScreen()));
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
        FlutterNativeSplash.remove();
        widget.navigatorKey.pushReplacement(MaterialPageRoute(builder: (context) => const LandingScreen()));
      }
    }
  }

  // Future<void> zegoLogin({id, userName}) async {
  //   await ZIMKit().connectUser(id: id, name: userName);
  //   ZegoUIKitPrebuiltCallInvitationService().init(
  //     appID: appID,
  //     appSign: appSign,
  //     userID: id,
  //     userName: userName,
  //     plugins: [ZegoUIKitSignalingPlugin()],

  //     // Modify your custom configurations here.
  //     ringtoneConfig: ZegoCallRingtoneConfig(
  //       incomingCallPath: "assets/ringtone/incomingCallRingtone.mp3",
  //       outgoingCallPath: "assets/ringtone/outgoingCallRingtone.mp3",
  //     ),
  //     requireConfig: (ZegoCallInvitationData data) {
  //       var config = (data.invitees.length > 1)
  //           ? ZegoCallInvitationType.videoCall == data.type
  //               ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
  //               : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
  //           : ZegoCallInvitationType.videoCall == data.type
  //               ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
  //               : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

  //       /// show minimizing button
  //       config.topMenuBar.isVisible = true;
  //       config.topMenuBar.buttons.insert(0, ZegoCallMenuBarButtonName.minimizingButton);

  //       return config;
  //     },
  //   );

  //   // await ZegoUIKitPrebuiltCallInvitationService()
  //   //     .send(invitees: invitees, isVideoCall: isVideoCall);
  //   // debugPrint('Connected to zego $rsp');
  // }

  getProfile() async {
    prefs = await SharedPreferences.getInstance();
    try {
      // final response = await _profileApi.profileApi();
      // debugPrint('>>>>>>>>>>$response<<<<<<<<<<<<');
      // await UserInfoSaver().infoSaver(response['id'], response['avatar'], response['full_name'], response['bio'], response['is_active'], response['date_joined']);
      if (Variables.token != '') {
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
        // if (Variables.isOnline) {
        //   await zegoLogin(
        //     id: Variables.phoneNumber,
        //     userName: Variables.fullNameString,
        //   );
        // }
        FlutterNativeSplash.remove();
        widget.navigatorKey.pushReplacement(MaterialPageRoute(builder: (context) => MobileLayoutScreen()));
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!!$e!!!!!!');
    }
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

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LanguageSelecterBloc()..add(StoredLocaleEvent())),
        BlocProvider(create: (context) => GroupBloc()),
        BlocProvider(create: (ctx) => ParticipantsBloc()),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => MessageBloc()),
        BlocProvider(create: (context) => ChannelBloc()..add(FetchChannelsEvent())),
        BlocProvider(create: (context) => ChannelMessageBloc()),
      ],
      child: BlocBuilder<LanguageSelecterBloc, LanguageSelecterState>(
        builder: (context, state) {
          _startTimer(context);
          return AdaptiveTheme(
            light: ThemeData(
              brightness: Brightness.light,
              colorScheme: const ColorScheme.light().copyWith(
                primary: Color.fromARGB(255, 57, 88, 68),
                secondary: Color.fromARGB(255, 25, 3, 68),
                // surface: const Color(0xFF00FFAB),
                // ignore: deprecated_member_use
                surface: Colors.white,
                // background: Colors.white,
                // ignore: deprecated_member_use
                onBackground: Color.fromARGB(255, 3, 3, 3),
              ),
              scaffoldBackgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Color(0xFF172774)),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              textTheme: const TextTheme(
                titleLarge: TextStyle(color: Colors.black),
                titleMedium: TextStyle(color: Colors.black),
                titleSmall: TextStyle(color: Colors.black),
                bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.black),
                bodySmall: TextStyle(color: Colors.black),
              ),
            ),
            dark: ThemeData(
              brightness: Brightness.dark,
              colorScheme: const ColorScheme.dark().copyWith(
                primary: Color.fromARGB(255, 42, 63, 170),
                secondary: Color.fromARGB(255, 17, 7, 65),
                surface: Colors.white,
                background: Colors.black87,
                // background: appBarColor,
                onBackground: Colors.white,
              ),
              scaffoldBackgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              textTheme: const TextTheme(
                titleLarge: TextStyle(color: Colors.white),
                titleMedium: TextStyle(color: Colors.white),
                titleSmall: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white),
              ),
            ),
            initial: AdaptiveThemeMode.dark,
            builder: (theme, darkTheme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Uhuru Chat',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: state.locale,
              theme: theme,
              darkTheme: darkTheme,
              navigatorKey: widget.navigatorKey,
              onGenerateRoute: (settings) => generateroute(settings),
              home: ZegoUIKitPrebuiltCallMiniPopScope(child: SplashScreen()),
              builder: (BuildContext context, Widget? child) {
                return Stack(
                  children: [
                    child!,
                    ZegoUIKitPrebuiltCallMiniOverlayPage(
                      contextQuery: () {
                        return widget.navigatorKey.currentState!.context;
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
