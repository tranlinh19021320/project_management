import 'package:flutter/material.dart';
import 'package:project_management/home/notifications/notifications_list.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';
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
    return mainScreen(IS_MANAGER_NOTIFY_PAGE, body: const NotificationsScreen());
  }
}
