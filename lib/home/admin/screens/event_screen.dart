import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../widgets/drawer_bar.dart';

class EventScreen extends StatefulWidget {
  final String userId;
  const EventScreen({super.key, required this.userId});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(backgroundImage), fit: BoxFit.fill),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: darkblueAppbarColor,
          title: const Text("Sự kiện"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: notifyIcon(3),
            )
          ],
        ),
        drawer: DrawerMenu(selectedPage: IS_EVENT_PAGE, userId: widget.userId,),
        body: const Text("..."),
      ),
    );
  }
}