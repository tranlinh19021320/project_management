import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/utils/create_mission.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
class MissionsScreen extends StatefulWidget {
  final Project project;
  const MissionsScreen({super.key, required this.project});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  TextEditingController nameProject = TextEditingController();
  TextEditingController description = TextEditingController();
  ScrollController descriptionScroll = ScrollController();
  late FocusNode nameFocus;
  late FocusNode descriptionFocus;

  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    nameFocus = FocusNode();
    nameFocus.addListener(() {
      if (nameFocus.hasFocus) {
        setState(() {});
      }
    });
    descriptionFocus = FocusNode();
    descriptionFocus.addListener(() {
      if (descriptionFocus.hasFocus) {
        setState(() {});
      }
    });
    startDate = widget.project.startDate;
    endDate = widget.project.endDate;
    nameProject.text = widget.project.nameProject;
    description.text = widget.project.description;
  }

  @override
  void dispose() {
    super.dispose();
    nameProject.dispose();
    description.dispose();
    nameFocus.dispose();
    descriptionFocus.dispose();
    descriptionScroll.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: const Text('hahaa'),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreateMissionScreen(project: widget.project))),
        child: const Icon(Icons.create),
      ),
    );
  }
}
