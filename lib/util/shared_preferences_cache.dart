part of 'enter.dart';

class SharedPreferencesCache {
  static late SharedPreferences _prefs;

  static init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
  }

  save(String key, Map<String, dynamic> data) {
    _prefs.setString(key, jsonEncode(data));
  }

  Map<String, dynamic> getData(String key) {
    String? str = _prefs.getString(key);
    if (str != null) {
      return jsonDecode(str);
    } else {
      return {};
    }
  }

  clear() {
    _prefs.clear();
  }
}
