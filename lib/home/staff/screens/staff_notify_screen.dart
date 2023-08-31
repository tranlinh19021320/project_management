import 'package:flutter/material.dart';
import 'package:project_management/home/staff/utils/staff_drawer.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';


class StaffNotifyScreen extends StatefulWidget {
  const StaffNotifyScreen({super.key});

  @override
  State<StaffNotifyScreen> createState() => _StaffNotifyScreenState();
}

class _StaffNotifyScreenState extends State<StaffNotifyScreen> {
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
          title: const Text("Thông báo"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: notifications(3),
            )
          ],
        ),
        drawer:const StaffDrawerMenu(selectedPage: IS_NOTIFY_PAGE,),
        body: const Text("..."),
      ),
    );
  }
}