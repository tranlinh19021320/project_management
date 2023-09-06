import 'package:flutter/material.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';

import '../utils/staff_drawer.dart';

class StaffEventScreen extends StatefulWidget {
  const StaffEventScreen({super.key});

  @override
  State<StaffEventScreen> createState() => _StaffEventScreenState();
}

class _StaffEventScreenState extends State<StaffEventScreen> {
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
          title: const Text("Sự kiện"),
          leading: Builder(
                    builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: menuIcon()),
                  ),
        ),
        drawer:const StaffDrawerMenu(selectedPage: IS_EVENT_PAGE,),
        body: const Text("..."),
      ),
    );
  }
}