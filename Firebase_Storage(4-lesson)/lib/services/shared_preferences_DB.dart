import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceDB{
  static Future<bool> setUserID(String user_ID) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_ID', user_ID);
  }

  static Future<String?> getUserID() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_ID');
  return token;
  }

  static Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('user_id');
  }
}