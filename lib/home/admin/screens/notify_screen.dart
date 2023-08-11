import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../widgets/drawer_bar.dart';
class NotifyScreen extends StatefulWidget {
  final String userId;
  const NotifyScreen({
    super.key, required this.userId,
  });

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
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
          title: const Text("Thông báo"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: notifyIcon(3),
            )
          ],
        ),
        drawer: DrawerMenu(selectedPage: IS_NOTIFY_PAGE, userId: widget.userId,),
        body: const Text("..."),
      ),
    );
  }
}
