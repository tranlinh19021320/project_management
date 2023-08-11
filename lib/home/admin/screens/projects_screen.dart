import 'package:flutter/material.dart';
import 'package:project_management/home/admin/widgets/drawer_bar.dart';
import 'package:project_management/utils/utils.dart';

class ProjectsScreen extends StatefulWidget {
  final String userId;
  const ProjectsScreen({super.key, required this.userId});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: notifyIcon(3),
            )
          ],
        ),
        drawer: DrawerMenu(selectedPage: IS_PROJECTS_PAGE,userId :widget.userId),
        body: const Text("..."),
      ),
    );
  }
}
