
import 'package:flutter/material.dart';
import 'package:project_management/home/admin/projects_screen.dart';
import 'package:project_management/home/staff/staff_home.dart';
import 'package:project_management/provider/user_provider.dart';
import 'package:project_management/utils/utils.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({
    super.key, required this.userId, 
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    await user.getUserById(widget.userId);
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      
    });
    return context.watch<UserProvider>().getCurrentUser.group == manager
        ? const ProjectsScreen()
        : const StaffHomeScreen();
  }
}
