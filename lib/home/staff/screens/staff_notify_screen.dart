import 'package:flutter/material.dart';
import 'package:project_management/home/widgets/notifications/notifications_list.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';


class StaffNotifyScreen extends StatefulWidget {
  const StaffNotifyScreen({super.key});

  @override
  State<StaffNotifyScreen> createState() => _StaffNotifyScreenState();
}

class _StaffNotifyScreenState extends State<StaffNotifyScreen> {
  @override
  Widget build(BuildContext context) {
    return mainScreen(IS_STAFF_NOTIFY_PAGE,  body: const NotificationsScreen());
  }
}