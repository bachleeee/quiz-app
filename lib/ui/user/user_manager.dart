import 'package:ct484_project/services/auth_service.dart';

import '../../services/user_service.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';

class UserManager extends ChangeNotifier {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  List<User> _users = [];

  int get userCount {
    return _users.length;
  }

  List<User> get users {
    return [..._users];
  }

  User? findById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (error) {
      return null;
    }
  }

  void addUser(User newUser) {
    _users.add(newUser);
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    final userIndex = _users.indexWhere((user) => user.id == updatedUser.id);
    if (userIndex >= 0) {
      final updateUser = await _userService.updateUser(updatedUser);
      if (updateUser != null) {
        _users[userIndex] = updatedUser;
        notifyListeners();
      }
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  Future<User?> fetchCurrentUser() async {
    try {
      final currentUser = await _authService.getUserFromStore();
      if (currentUser != null) {
        _users.add(currentUser);
        notifyListeners();
      }
      return currentUser;
    } catch (error) {
      print("Error fetching current user: $error");
    }
    return null;
  }

  Future<void> updateUserScore(int newScore) async {
    try {
      final updatedUser = await _userService.updateUserScore(newScore);
      if (updatedUser != null) {
        final userIndex =
            _users.indexWhere((user) => user.id == updatedUser.id);
        if (userIndex >= 0) {
          _users[userIndex] = updatedUser;
          notifyListeners();
        }
      }
    } catch (error) {
      print("Error updating score: $error");
    }
  }

  Future<void> updateUserCoins(User thisUser, int newCoins) async {
    final userIndex = _users.indexWhere((user) => user.id == thisUser.id);

    try {
      final updatedUser =
          await _userService.updateUserCoins(thisUser, newCoins);
      if (updatedUser != null) {
        if (userIndex >= 0) {
          _users[userIndex] = updatedUser;
          notifyListeners();
        }
      }
    } catch (error) {
      print("Error updating score: $error");
    }
  }

  Future<void> fetchUsers() async {
    _users = await _userService.fetchUsers();
    print('Danh sach user $_users');
    notifyListeners();
  }
  // Future<void> fetchUser() async {
  //   _users = await _UserService.getUserFromStore();
  //   notifyListeners();
  // }
}
