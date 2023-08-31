
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/screens/projects_screen.dart';
import 'package:project_management/home/staff/screens/staff_home.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/parameters.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String group = "Devs1";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    CurrentUser user = await FirebaseMethods().getCurrentUserByUserId(userId: FirebaseAuth.instance.currentUser!.uid);
    group = user.group;
    setState(() {
      isLoading = false;
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading?const Center(
      child: CircularProgressIndicator(backgroundColor: Colors.transparent,),
    ): group == manager
        ? const ProjectsScreen()
        : const StaffHomeScreen();
  }
}
