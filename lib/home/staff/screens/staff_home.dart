import 'package:flutter/material.dart';
import 'package:project_management/home/widgets/missions/missions_list.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';


class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key,});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return mainScreen(IS_QUEST_PAGE, body: const MissionsScreen());
  }
}