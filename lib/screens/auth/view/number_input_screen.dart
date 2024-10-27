import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhuru/common/colors.dart';
import 'package:uhuru/common/utils/variables.dart';
import 'package:uhuru/common/utils/utils.dart';
import '../../../common/utils/loader_dialog.dart';
import '../../splashscreen/model/account_verification_model.dart';
import '../../user_profile/api/profile_api.dart';
import '../../user_profile/model/user_info_saver.dart';
import 'auth_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login_screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final _profileApi = Get.put(ProfileApi());
  Country? country;
  final _accountVerificationModel = Get.put(AccountVerificationModel());
  late SharedPreferences prefs;
  String _userAgent = '<unknown>';
  String _webUserAgent = '<unknown>';

  ///This will save a new token received after login
  tokenSaver(token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('phonenumber', phoneController.text);
  }

  Future<void> initFunctions() async {
    await initUserAgentState();
    await accountVerification(Variables.phoneNumber, "${Variables.phoneNumber}$_userAgent");
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

  bool isLoginScreen(Route route) {
    return route.settings.name == LoginScreen.routeName;
  }

  ///This will verify the current PhoneNumber for account access
  accountVerification(phoneNumber, password) async {
    LoaderDialog.showLoader(context!, Variables.keyLoader);
    prefs = await SharedPreferences.getInstance();
    try {
      final response = await _accountVerificationModel.accountVerificationModel(phoneNumber, password);

      if (response['access'] != null) {
        print('-*****ACCOUNT VERIFIED*****->$response');
        await tokenSaver(response['access']);
        setState(() {
          Variables.token = prefs.getString('token')!;
          Variables.phoneNumber = prefs.getString('phonenumber')!;
          Variables.signUp = false;
          Variables.signIn = false;
          Variables.updateProfile = true;
        });
        print('-*****NEW TOKEN*****->${Variables.token}');
        await getProfile();
      } else {
        print('-*****NO TOKEN CREATED*****->$response');
        setState(() {
          Variables.signUp = true;
          Variables.signIn = false;
          Variables.updateProfile = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const UserInformation())).then((_) => Navigator.of(context).popUntil(isLoginScreen));
      }
    } catch (e) {
      print('**********This is the exception!!!!$e!!!!!!');
      if (Variables.dioResponseExceptionData != null && Variables.dioResponseExceptionData['detail'] == 'No active account found with the given credentials') {
        print('-*****NO TOKEN CREATED*****->YOU WILL HAVE TO SIGNUP WITH THE DISPLAYED SCREEN');
        setState(() {
          Variables.signUp = true;
          Variables.signIn = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const UserInformation())).then((_) => Navigator.of(context).popUntil(isLoginScreen));
      }
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
          Variables.fullName.text = prefs.getString('full_name')!;
          Variables.bioString = prefs.getString('bio')!;
          Variables.bio.text = prefs.getString('bio')!;
          Variables.isActive = prefs.getBool('is_active')!;
          Variables.dateJoined = prefs.getString('date_joined')!;
        });
        debugPrint('>>>>>>>>>>${Variables.id}<<<<<<<<<<<<');
        debugPrint('>>>>>>>>>>${Variables.fullNameString}<<<<<<<<<<<<');
        if (Variables.updateProfile) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const UserInformation())).then((_) => Navigator.of(context).popUntil(isLoginScreen));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const UserInformation())).then((_) => Navigator.of(context).popUntil(isLoginScreen));
        }
      }
    } catch (e) {
      debugPrint('**********This is the exception!!!!$e!!!!!!');
    }
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country2) {
          setState(() {
            country = country2;
          });
          print('-----$country---------');
        });
  }

  Future<void> sendNumber() async {
    String phoneNumber = phoneController.text.trim();
    setState(() {
      Variables.signIn = true;
      Variables.signUp = false;
    });
    if (country != null && phoneNumber.isNotEmpty) {
      setState(() {
        Variables.countryCode = "+${country!.phoneCode}";
        Variables.countryName = country!.name;
        Variables.countryIso = country!.countryCode;
        Variables.phoneNumber = phoneController.text;
      });
      if (Variables.signIn) {
        print('==========SIGNED IN AS ${Variables.phoneNumber}============');
        await initFunctions();
      } else if (Variables.signUp) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const UserInformation())).then((_) => Navigator.of(context).popUntil(isLoginScreen));
      }
    } else {
      showSnackBar(context: context, content: "Fill out all the fields");
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.entreyourphonenumber),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.verifythemessagesendingbyuhuruchat),
              const SizedBox(height: 3),
              TextButton(
                onPressed: pickCountry,
                child: Text(
                  AppLocalizations.of(context)!.chooseyourcountry,
                  style: TextStyle(color: Colors.cyan),
                ),
              ),
              const SizedBox(height: 3),
              if (country != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (country != null) Text("+${country!.phoneCode}"),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        decoration: InputDecoration(hintText: AppLocalizations.of(context)!.enteryournumber),
                      ),
                    )
                  ],
                ),
              SizedBox(height: 15),
              if (country != null)
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    onPressed: sendNumber,
                    child: Text(AppLocalizations.of(context)!.next),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
