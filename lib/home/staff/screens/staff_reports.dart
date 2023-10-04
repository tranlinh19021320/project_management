import 'package:flutter/material.dart';
import 'package:project_management/home/widgets/reports/report_detail.dart';
import 'package:project_management/home/widgets/reports/reports_screen.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';


class StaffReportsScreen extends StatefulWidget {
  const StaffReportsScreen({super.key});

  @override
  State<StaffReportsScreen> createState() => _StaffReportsScreenState();
}

class _StaffReportsScreenState extends State<StaffReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return mainScreen(IS_REPORT_PAGE,
        
        body: const ReportsScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const ReportDetail())),
          tooltip: "Tạo báo cáo mới",
          child: const Icon(Icons.add),
        ));
  }
}
