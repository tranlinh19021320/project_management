import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/utils.dart';
import 'package:intl/intl.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
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
    startDate = DateTime.now();
    endDate = DateTime.now();
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

  createproject() async {
    if (nameProject.text != "") {
      String projectId = const Uuid().v1();
      String res = await FirebaseMethods().createProject(
          projectId: projectId,
          nameProject: nameProject.text,
          description: description.text,
          startDate: startDate.toString(),
          endDate: endDate.toString());
      if (res == 'success') {
        if (context.mounted) {
          showSnackBar(context, "tạo project thành công", false);
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, res, false);
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
          title: const Text('Dự án mới'),
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
          onPressed: createproject,
          tooltip: "Tạo",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
