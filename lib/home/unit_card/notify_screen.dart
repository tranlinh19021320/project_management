import 'package:flutter/material.dart';
import 'package:project_management/home/admin/drawer_bar.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({
    super.key,
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
            image: AssetImage(backgroundImage), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: darkblueAppbarColor,
          title: const Text("Thông báo"),
        ),
        drawer: const DrawerBar(),
        body: const Center(child: Text('...')),
      ),
    );
  }
}
