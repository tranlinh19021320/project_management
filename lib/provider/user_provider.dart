import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/user.dart';

class UserProvider extends ChangeNotifier {
  CurrentUser? _user;
  final FirebaseMethods _firebaseMethods = FirebaseMethods();
  CurrentUser get getCurrentUser => _user!;

  Future<void> getUserById(String userId) async {
    CurrentUser user = await _firebaseMethods.getCurrentUserByUserId(userId);
    _user = user;
    notifyListeners();
  }

  Future<String> updateUser(String email, String nameDetails) async {
    String userId = _user!.userId;
    String res = await _firebaseMethods.updateProfile(userId, email, nameDetails);

    if (res == "success") {
      getUserById(userId);
    }

    return res;
  }

  String getEmail() {
    return _user!.email;
  }

  String getDetailName() {
    return _user!.nameDetails;
  }

  String getUserId() {
    return _user!.userId;
  }

  String getUsername() {
    return _user!.username;
  }

  String getRole() {
    return _user!.role;
  }

  bool getIsManager() {
    return _user!.isManager;
  }
}
