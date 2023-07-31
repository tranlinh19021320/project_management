import 'package:flutter/material.dart';
import 'package:project_management/admin/personal_screen.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/admin/drawer_bar.dart';

import '../stateparams/utils.dart';

class AdminHomeScreen extends StatefulWidget {
  final String userId;
  const AdminHomeScreen({super.key, required this.userId, });

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(backgroundImage), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: darkblueAppbarColor,
          title: const Text("Dự án"),
        ),
        drawer: DrawerBar(page: IS_PROJECTS_PAGE, userId: widget.userId),
        body: const Center(child: Text('...')),
      ),
    );
  }
}
