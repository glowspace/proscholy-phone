import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static final shared = Global._();

  Global._();

  SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }
}
