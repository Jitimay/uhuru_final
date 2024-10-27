
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoSaver{
  late SharedPreferences prefs;

  Future<dynamic> infoSaver(id, avatar, full_name, bio, is_active, date_joined) async{
    prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
    prefs.setString('avatar', avatar);
    prefs.setString('full_name', full_name);
    prefs.setString('bio', bio);
    prefs.setBool('is_active', is_active);
    prefs.setString('date_joined', date_joined);
  }
}