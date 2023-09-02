
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/screens/projects_screen.dart';
import 'package:project_management/home/staff/screens/staff_home.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isManager;
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
    GroupProvider groupProvider = Provider.of<GroupProvider>(context, listen: false);
    await groupProvider.refresh();
    isManager = groupProvider.getIsManager;
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
    ): isManager
        ? const ProjectsScreen()
        : const StaffHomeScreen();
  }
}
