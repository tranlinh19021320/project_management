import 'package:flutter/material.dart';
import 'package:project_management/home/widgets/reports/reports_screen.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

class EventScreen extends StatefulWidget {

  const EventScreen({super.key, });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return mainScreen(IS_EVENT_PAGE, body: const ReportsScreen());
  }
}