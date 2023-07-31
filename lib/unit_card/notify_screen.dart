import 'package:flutter/material.dart';
import 'package:project_management/admin/personal_screen.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/admin/drawer_bar.dart';

import '../stateparams/utils.dart';

class NotifyScreen extends StatefulWidget {
  final String userId;
  const NotifyScreen({super.key, required this.userId, });

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
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
        ),
        drawer: DrawerBar(page: IS_NOTIFY_PAGE, userId: widget.userId),
        body: const Center(child: Text('...')),
      ),
    );
  }
}
