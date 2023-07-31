import 'package:flutter/material.dart';
import 'package:project_management/model/user.dart';

import '../stateparams/utils.dart';
import 'drawer_bar.dart';

class PersonalScreen extends StatefulWidget {
  final String userId;
  const PersonalScreen({super.key, required this.userId,});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
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
            title: const Text("Nhân sự"),
          ),
          drawer: DrawerBar(page: IS_PERSONAL_PAGE, userId: widget.userId),
        body: const Center(child: Text('...')),
      ),
    );
  }
}