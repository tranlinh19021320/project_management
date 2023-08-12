import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../widgets/staff_drawer.dart';

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
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: notifications(3),
            )
          ],
        ),
        drawer:const StaffDrawerMenu(selectedPage: IS_EVENT_PAGE,),
        body: const Text("..."),
      ),
    );
  }
}