import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_storage_service.dart';

enum LoginFailure { noRegisteredUser, phoneNotFound, emptyPassword }

class LoginResult {
  const LoginResult.success() : failure = null;
  const LoginResult.failure(this.failure);

  final LoginFailure? failure;
  bool get isSuccess => failure == null;

  String get message => switch (failure) {
    LoginFailure.noRegisteredUser => 'Önce bir hesap oluşturmalısınız.',
    LoginFailure.phoneNotFound =>
      'Bu telefon numarasıyla kayıtlı kullanıcı bulunamadı.',
    LoginFailure.emptyPassword => 'Şifrenizi girin.',
    null => '',
  };
}

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthStorageService? storage})
    : _storage = storage ?? AuthStorageService();

  final AuthStorageService _storage;
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = true;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await _storage.readUser();
    _isLoggedIn = _currentUser != null && await _storage.readIsLoggedIn();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(UserModel user) async {
    _currentUser = user;
    _isLoggedIn = false;
    await _storage.saveUser(user);
    await _storage.setLoggedIn(false);
    notifyListeners();
  }

  Future<bool> verifyOtp(String code) async {
    if (code.trim().isEmpty || _currentUser == null) return false;
    _isLoggedIn = true;
    await _storage.setLoggedIn(true);
    notifyListeners();
    return true;
  }

  Future<LoginResult> login({
    required String phone,
    required String password,
  }) async {
    final user = _currentUser ?? await _storage.readUser();
    _currentUser = user;
    if (user == null) {
      return const LoginResult.failure(LoginFailure.noRegisteredUser);
    }
    if (phone.trim() != user.phone.trim()) {
      return const LoginResult.failure(LoginFailure.phoneNotFound);
    }
    if (password.trim().isEmpty) {
      return const LoginResult.failure(LoginFailure.emptyPassword);
    }

    // Prototip kuralı: kayıtlı telefon ve dolu bir parola yeterlidir.
    _isLoggedIn = true;
    await _storage.setLoggedIn(true);
    notifyListeners();
    return const LoginResult.success();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await _storage.setLoggedIn(false);
    notifyListeners();
  }
}
