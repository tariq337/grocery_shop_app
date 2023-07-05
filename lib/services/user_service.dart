import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('apiKey') ?? '';
}

Future<String> setToken(String token) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  try {
    await pref.remove('apiKey');
    await pref.setString('apiKey', token);
    return pref.getString('apiKey') ?? '';
  } catch (e) {
    return '';
  }
}

Future<bool> removToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('apiKey');
}
