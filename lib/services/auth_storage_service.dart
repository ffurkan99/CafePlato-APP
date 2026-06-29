import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthStorageService {
  static const _userKey = 'cafeplato_user';
  static const _loggedInKey = 'cafeplato_is_logged_in';

  Future<UserModel?> readUser() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedUser = preferences.getString(_userKey);
    if (encodedUser == null || encodedUser.isEmpty) return null;

    try {
      return UserModel.decode(encodedUser);
    } on FormatException {
      return null;
    }
  }

  Future<bool> readIsLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_loggedInKey) ?? false;
  }

  Future<void> saveUser(UserModel user) async {
    final preferences = await SharedPreferences.getInstance();
    // TODO: Production'da parolayı düz metin olarak cihazda saklamayın.
    await preferences.setString(_userKey, user.encode());
  }

  Future<void> setLoggedIn(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_loggedInKey, value);
  }
}
