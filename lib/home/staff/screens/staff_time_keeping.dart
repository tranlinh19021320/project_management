import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/home/widgets/timetracking/time_keeping_table.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';


class StaffTimeKeepingScreen extends StatefulWidget {
  const StaffTimeKeepingScreen({super.key});

  @override
  State<StaffTimeKeepingScreen> createState() => _StaffTimeKeepingScreenState();
}

class _StaffTimeKeepingScreenState extends State<StaffTimeKeepingScreen> {
  @override
  Widget build(BuildContext context) {
    return mainScreen(IS_TIME_KEEPING_PAGE,
        body: TimeKeepingTable(userId: FirebaseAuth.instance.currentUser!.uid));
  }
}
