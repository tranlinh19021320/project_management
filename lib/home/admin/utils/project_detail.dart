import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project? project;
  const ProjectDetailScreen({super.key, this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  TextEditingController nameProject = TextEditingController();
  TextEditingController description = TextEditingController();
  ScrollController descriptionScroll = ScrollController();
  late FocusNode nameFocus;
  late FocusNode descriptionFocus;

  late DateTime startDate;
  late DateTime endDate;

  late bool isManager;

  

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
    init();
    
    
  }
  
  init() {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
    if (widget.project != null) {
    startDate = widget.project!.startDate;
    endDate = widget.project!.endDate;
    nameProject.text = widget.project!.nameProject;
    description.text = widget.project!.description;
    } else {
      startDate = DateTime.now();
      endDate = DateTime.now();
    }
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

  bool ischanged()  {
    return (nameProject.text != widget.project!.nameProject ||
        description.text != widget.project!.description ||
        !startDate.isAtSameMomentAs(widget.project!.startDate) ||
        !endDate.isAtSameMomentAs(widget.project!.endDate));
  }

  updateProject() async {
    if (ischanged()) {
      showDialog(
          context: context,
          builder: (_) => const NotifyDialog(content: 'loading'));
      String res = await FirebaseMethods().updateProject(
          project: widget.project!,
          nameProject: nameProject.text,
          description: description.text,
          startDate: startDate,
          endDate: endDate);
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (res == 'success') {
        if (context.mounted) {
          
          showDialog(
          context: context,
          builder: (_) => const NotifyDialog(content: 'Cập nhật thành công!'));
        }
      } else {
        if (context.mounted) {
          showSnackBar(context: context, content: res, isError: true);
        }
      }
    }
  }

  createproject() async {
    if (nameProject.text != "") {
      String projectId = const Uuid().v1();
      String res = await FirebaseMethods().createProject(
          projectId: projectId,
          nameProject: nameProject.text,
          description: description.text,
          startDate: startDate,
          endDate: endDate);
      if (res == 'success') {
        if (context.mounted) {
          showSnackBar(context:context,content: "tạo project thành công",);
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          showSnackBar(context:context,content: res, isError: true);
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name
              const Text("Tên dự án"),
              const SizedBox(
                height: 4,
              ),
              TextField(
                controller: nameProject,
                focusNode: nameFocus,
                style: const TextStyle(color: blackColor),
                decoration: InputDecoration(
                  filled: true,
                  helperText: (nameProject.text != "")
                      ? ""
                      : 'Vui lòng điền tên dự án!',
                  fillColor: (isManager) ? backgroundWhiteColor : defaultColor,
                ),
                readOnly: !isManager,
                onTapOutside: (_) => nameFocus.unfocus(),
                onSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(descriptionFocus),
              ),
              const SizedBox(
                height: 4,
              ),

              //description
              const Text("Mô tả"),
              const SizedBox(
                height: 4,
              ),

              TextField(
                controller: description,
                focusNode: descriptionFocus,
                style: const TextStyle(color: blackColor),
                decoration: InputDecoration(
                  filled: true,
                  helperText: "",
                  fillColor: (isManager) ? backgroundWhiteColor : defaultColor,
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: null,
                
                scrollController: descriptionScroll,
                readOnly: !isManager,
                onTapOutside: (event) => descriptionFocus.unfocus(),
              ),

              // date
              const Text(
                'Thời gian dự án',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 12,
              ),

              Row(
                children: [
                  InkWell(
                    onTap:  !isManager ? () {} : () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 10),
                        locale: const Locale('vi'),
                        currentDate: startDate,
                      );
                      if (date != null) {
                        setState(() {
                          startDate = date;
                          if (startDate.isAfter(endDate)) {
                            endDate = startDate;
                          }
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 4),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        color: backgroundWhiteColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat('dd/MM/yyy').format(startDate),
                            style: const TextStyle(color: blackColor),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: defaultColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text('  -  '),
                  InkWell(
                    onTap:!isManager ? () {} : () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: startDate,
                        lastDate: DateTime(DateTime.now().year + 10),
                        locale: const Locale('vi'),
                        currentDate: endDate,
                      );
                      if (date != null) {
                        setState(() {
                          if (startDate.isAfter(date)) {
                            endDate = startDate;
                          } else {
                            endDate = date;
                          }
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 4),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        color: backgroundWhiteColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat('dd/MM/yyy').format(endDate),
                            style: const TextStyle(color: blackColor),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: defaultColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:!isManager ? null: (widget.project != null) ? FloatingActionButton(
        onPressed: updateProject,
        child: const Icon(Icons.update),
      ) : FloatingActionButton(
          onPressed: createproject,
          tooltip: "Tạo",
          child: const Icon(Icons.add),
        ),
    );
  }
}
