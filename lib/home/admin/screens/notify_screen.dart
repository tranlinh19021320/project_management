import 'package:flutter/material.dart';
import 'package:project_management/home/notifications/notifications_list.dart';

import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';
import '../utils/drawer_bar.dart';
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
            image: AssetImage(backgroundImage), fit: BoxFit.fill),),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: darkblueAppbarColor,
          title: const Text("Thông báo"),
          leading: Builder(
                    builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: menuIcon()),
                  ),
        ),
        drawer:const  DrawerMenu(selectedPage: IS_NOTIFY_PAGE,),
        body: const NotificationsScreen()
      ),
    );
  }
}
