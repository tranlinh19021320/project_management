import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/notify_dialog.dart';
import '../../utils/utils.dart';

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

  delete() async {
    bool? comfirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              scrollable: true,
              backgroundColor: darkblueAppbarColor,
              iconPadding: const EdgeInsets.only(bottom: 8),
              icon: loudspeakerIcon,
              title: Column(
                children: [
                  Text(
                      "Bạn chắc muốn xóa dự án '' ${widget.project.nameProject} '' ?",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Dự án sẽ bị xóa vĩnh viễn!",
                    style: TextStyle(color: errorRedColor, fontSize: 12),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actionsPadding: const EdgeInsets.only(bottom: 14),
              actions: [
                TextBoxButton(
                    color: dartblueColor,
                    text: "Ok",
                    fontSize: 14,
                    width: 64,
                    height: 36,
                    funtion: () => Navigator.of(context).pop(true)),
                TextBoxButton(
                    color: errorRedColor,
                    text: "Hủy",
                    fontSize: 14,
                    width: 64,
                    height: 36,
                    funtion: () => Navigator.of(context).pop(false)),
              ],
            ));

    if (comfirm != null && comfirm) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (_) => const NotifyDialog(
                  content: "loading",
                ));
      }
      String res = await FirebaseMethods().deleteProject(
          companyId: widget.project.companyId,
          projectId: widget.project.projectId);

      if (res == 'success') {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (_) => const NotifyDialog(
                    content: "Đã xóa dự án thành công!",
                  ));
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          showSnackBar(context: context, content: res, isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Text('hahaa'),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.create),
      ),
    );
  }
}
