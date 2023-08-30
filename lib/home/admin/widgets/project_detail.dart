import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/notify_dialog.dart';
import '../../../utils/utils.dart';
import 'package:intl/intl.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;
  const ProjectDetailScreen({super.key, required this.project});

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

  // createproject() async {
  //   if (nameProject.text != "") {
  //     String projectId = const Uuid().v1();
  //     String res = await FirebaseMethods().createProject(
  //         projectId: projectId,
  //         nameProject: nameProject.text,
  //         description: description.text,
  //         startDate: startDate,
  //         endDate: endDate);
  //     if (res == 'success') {
  //       if (context.mounted) {
  //         showSnackBar(
  //           context: context,
  //           content: "tạo project thành công",
  //         );
  //         Navigator.pop(context);
  //       }
  //     } else {
  //       if (context.mounted) {
  //         showSnackBar(context: context, content: res, isError: false);
  //       }
  //     }
  //   }
  // }

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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(backgroundImage), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: darkblueAppbarColor,
          title: const Text('Dự án'),
          actions: [
            IconButton(
                onPressed: delete,
                tooltip: "Xóa vĩnh viễn",
                icon: const Icon(
                  Icons.delete_forever,
                  color: errorRedColor,
                ))
          ],
        ),
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
                    fillColor: backgroundWhiteColor,
                  ),
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
                  decoration: const InputDecoration(
                    filled: true,
                    helperText: "",
                    fillColor: backgroundWhiteColor,
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  scrollController: descriptionScroll,
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
                      onTap: () async {
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
                      onTap: () async {
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

                const SizedBox(
                  height: 6,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: "Tạo",
          child: const Icon(Icons.update),
        ),
      ),
    );
  }
}
