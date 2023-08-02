
import 'package:flutter/material.dart';
import 'package:project_management/home/admin/projects_screen.dart';
import 'package:project_management/home/staff/staff_home.dart';
class HomeScreen extends StatefulWidget {
  final bool isManager;
  const HomeScreen({
    super.key, required this.isManager,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.isManager
        ? const ProjectsScreen()
        : const StaffHomeScreen();
  }
}
