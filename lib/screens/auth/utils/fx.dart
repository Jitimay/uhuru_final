import 'package:shared_preferences/shared_preferences.dart';

class AuthUtilsFX {
  //
  late SharedPreferences prefs;

  Future<void> tokenSaver(token, phoneNumber) async {
    //
    prefs = await SharedPreferences.getInstance();

    prefs.setString('token', token);

    prefs.setString('phonenumber', phoneNumber);
  }
}
