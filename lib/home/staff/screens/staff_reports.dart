import 'package:flutter/material.dart';
import 'package:project_management/home/reports/report_detail.dart';
import 'package:project_management/home/reports/reports_screen.dart';
import 'package:project_management/home/widgets/page_list.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/paths.dart';

import '../utils/staff_drawer.dart';

class StaffReportsScreen extends StatefulWidget {
  const StaffReportsScreen({super.key});

  @override
  State<StaffReportsScreen> createState() => _StaffReportsScreenState();
}

class _StaffReportsScreenState extends State<StaffReportsScreen> {
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
          title: const Text("Báo cáo"),
          leading: Builder(
                    builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: menuIcon()),
                  ),
        ),
        drawer:const StaffDrawerMenu(selectedPage: IS_REPORT_PAGE,),
        body: const ReportsScreen(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReportDetail())),
        tooltip: "Tạo báo cáo mới",
        child: const Icon(Icons.add),
      ),
      ),
    );
  }
}