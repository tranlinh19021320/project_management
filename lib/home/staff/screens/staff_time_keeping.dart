import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/home/timetracking/time_keeping_table.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';

import '../utils/staff_drawer.dart';

class StaffTimeKeepingScreen extends StatefulWidget {
  const StaffTimeKeepingScreen({super.key});

  @override
  State<StaffTimeKeepingScreen> createState() => _StaffTimeKeepingScreenState();
}

class _StaffTimeKeepingScreenState extends State<StaffTimeKeepingScreen> {
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
          title: const Text("Bảng chấm công"),
          leading: Builder(
                    builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: menuIcon()),
                  ),
        ),
        drawer:const StaffDrawerMenu(selectedPage: IS_EVENT_PAGE,),
        body: TimeKeepingTable(userId: FirebaseAuth.instance.currentUser!.uid),
      ),
    );
  }
}