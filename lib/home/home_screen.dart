
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/screens/projects_screen.dart';
import 'package:project_management/home/staff/screens/staff_home.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/utils.dart';
class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({
    super.key, required this.userId, 
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
    CurrentUser user = await FirebaseMethods().getCurrentUserByUserId(userId: widget.userId);
    group = user.group;
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading?const Center(
      child: CircularProgressIndicator(backgroundColor: Colors.transparent,),
    ): group == manager
        ? ProjectsScreen(userId: widget.userId,)
        : const StaffHomeScreen();
  }
}
