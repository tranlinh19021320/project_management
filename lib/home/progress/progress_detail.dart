import 'package:flutter/material.dart';
import 'package:project_management/model/progress.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/paths.dart';
import 'package:provider/provider.dart';

class ProgressDetailScreen extends StatefulWidget {
  final Progress? progress;
  const ProgressDetailScreen({super.key, this.progress});

  @override
  State<ProgressDetailScreen> createState() => _ProgressDetailScreenState();
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  late bool isManager;
  @override
  void initState() {
    super.initState();
    GroupProvider groupProvider = Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
  }
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
          centerTitle: true,
          title: (widget.progress == null)
              ? const Text('Tạo submit')
              : Text((isToDay(day: widget.progress!.date))
                  ? "Hôm nay"
                  : widget.progress!.date),
        ),


      ),
    );
  }
}
