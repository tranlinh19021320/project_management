import 'package:flutter/material.dart';
import 'package:project_management/admin/admin_home.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/staff/staff_home.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId, });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CurrentUser currentUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  getCurrentUser() async {
    currentUser = await FirebaseMethods().getCurrentUserByUserId(widget.userId);
  }
  @override
  Widget build(BuildContext context) {
    return currentUser.isManager
        ? AdminHomeScreen(userId: widget.userId,)
        : StaffHomeScreen(userId: widget.userId,);
  }
}
