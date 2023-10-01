import 'package:flutter/material.dart';
import 'package:project_management/home/admin/screens/event_screen.dart';
import 'package:project_management/home/admin/screens/notify_screen.dart';
import 'package:project_management/home/admin/screens/personal_screen.dart';
import 'package:project_management/home/admin/screens/projects_screen.dart';
import 'package:project_management/home/staff/screens/staff_home.dart';
import 'package:project_management/home/staff/screens/staff_notify_screen.dart';
import 'package:project_management/home/staff/screens/staff_reports.dart';
import 'package:project_management/home/staff/screens/staff_time_keeping.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/paths.dart';

const int IS_PROJECTS_PAGE = 0;
const int IS_PERSONAL_PAGE = 1;
const int IS_MANAGER_NOTIFY_PAGE = 2;
const int IS_EVENT_PAGE = 3;
const int IS_QUEST_PAGE = 4;
const int IS_STAFF_NOTIFY_PAGE = 5;
const int IS_TIME_KEEPING_PAGE = 6;
const int IS_REPORT_PAGE = 7;

Widget leadingIcon({required int page}) {
  switch (page) {
    case IS_PROJECTS_PAGE:
      return projectIcon;
    case IS_PERSONAL_PAGE:
      return resizedIcon(staffImage, 30);
    case IS_MANAGER_NOTIFY_PAGE:
      return defaultnotifyIcon;
    case IS_EVENT_PAGE:
      return eventIcon;
    case IS_QUEST_PAGE:
      return projectIcon;
    case IS_STAFF_NOTIFY_PAGE:
      return defaultnotifyIcon;
    case IS_TIME_KEEPING_PAGE:
      return eventIcon;
    case IS_REPORT_PAGE:
      return loudspeakerIcon;
    default:
      return Container();
  }
}
String namePage({required int page}) {
  switch (page) {
    case IS_PROJECTS_PAGE:
      return "Dự án";
    case IS_PERSONAL_PAGE:
      return "Nhân sự";
    case IS_MANAGER_NOTIFY_PAGE:
      return "Thông báo";
    case IS_EVENT_PAGE:
      return "Sự kiện";
    case IS_QUEST_PAGE:
      return 'Nhiệm vụ';
    case IS_STAFF_NOTIFY_PAGE:
      return 'Thông báo';
    case IS_TIME_KEEPING_PAGE:
      return 'Bảng chấm công';
    case IS_REPORT_PAGE:
      return 'Báo cáo';
    default:
      return "";
  }
}

Widget screen({required int page}) {
  switch (page) {
    case IS_PROJECTS_PAGE:
        return const ProjectsScreen();
    case IS_PERSONAL_PAGE:
        return const PersonalScreen();
    case IS_MANAGER_NOTIFY_PAGE:
      return const NotifyScreen();
    case IS_EVENT_PAGE:
      return const EventScreen();
    case IS_QUEST_PAGE:
      return const StaffHomeScreen();
    case IS_STAFF_NOTIFY_PAGE:
      return const StaffNotifyScreen();
    case IS_TIME_KEEPING_PAGE:
      return const StaffTimeKeepingScreen();
    case IS_REPORT_PAGE:
      return const StaffReportsScreen();
    default:
      return Container();
  }
}