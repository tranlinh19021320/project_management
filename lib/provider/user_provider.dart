import 'dart:typed_data';

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

  Future<String> changePassword(String oldPassword, String newPassword)async {
    String userId = _user!.userId;

    String res = await _firebaseMethods.changePassword(userId, oldPassword, newPassword);

    if (res == "success") {
      getUserById(userId);
    }

    return res;
  }

  Future<String> changeImage(Uint8List image) async {

    String res = await _firebaseMethods.changeProfileImage(image, _user!.username, _user!.userId);

    if (res == "success") {
      getUserById(_user!.userId);
    }

    return res;
  }
  
}
