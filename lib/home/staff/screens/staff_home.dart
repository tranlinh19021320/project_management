import 'package:flutter/material.dart';
import 'package:project_management/home/staff/widgets/staff_drawer.dart';

import '../../../utils/utils.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key,});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {

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
          title: const Text("Nhiệm vụ"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: notifications(3),
            )
          ],
        ),
        drawer:const StaffDrawerMenu(selectedPage: IS_QUEST_PAGE,),
        body: const Text("..."),
      ),
    );
  }
}