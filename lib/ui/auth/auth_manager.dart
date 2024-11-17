import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';

class AuthManager with ChangeNotifier {
  late final AuthService _authService;

  User? _loggedInUser;
  int? begin;

  AuthManager() {
    _authService = AuthService(onAuthchange: (User? user) {
      _loggedInUser = user;
      begin = null;
      notifyListeners();
    });
  }

  bool get isAuth {
    return _loggedInUser != null;
  }

  bool get isBegin {
    return begin != null;
  }

  User? get user {
    return _loggedInUser;
  }

  Future<User> signup(String email, String password) {
    return _authService.signup(email, password);
  }

  Future<User> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<void> goLogin() async {
    begin = 1;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final user = await _authService.getUserFromStore();
    if (_loggedInUser != null) {
      _loggedInUser = user;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    return _authService.logout();
  }
}
