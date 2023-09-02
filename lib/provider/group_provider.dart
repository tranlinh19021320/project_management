import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/parameters.dart';

class GroupProvider with ChangeNotifier {
  bool? _isManager;
  bool get getIsManager => _isManager!;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMethods _firebaseMethods = FirebaseMethods();

  refresh() async {
    CurrentUser user = await _firebaseMethods.getCurrentUserByUserId(userId: _auth.currentUser!.uid);

    _isManager = (user.group == manager);
    notifyListeners();
  }

}