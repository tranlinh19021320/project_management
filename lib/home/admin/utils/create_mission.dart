import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/group_dropdown_button.dart';
import 'package:project_management/home/widgets/search_user.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/paths.dart';
import 'package:uuid/uuid.dart';

class CreateMissionScreen extends StatefulWidget {
  final Project project;
  const CreateMissionScreen({super.key, required this.project});

  @override
  State<CreateMissionScreen> createState() => _CreateMissionScreenState();
}

class _CreateMissionScreenState extends State<CreateMissionScreen> {
  TextEditingController nameMission = TextEditingController();
  TextEditingController description = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  ScrollController descriptionScroll = ScrollController();

  late DateTime startDate;
  late DateTime endDate;

  String selectuserId = '';

  String groupSelect = "Tất cả";

  late GroupDropdownButton groupDropdownButton;
  late SearchUser searchUser;
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    startDate = (now.isBefore(widget.project.startDate))
        ? widget.project.startDate
        : now;
    endDate = startDate;

    groupDropdownButton = GroupDropdownButton(
        companyId: widget.project.companyId,
        groupSelect: groupSelect,
        isWordAtHead: "Tất cả",
        onSelectValue: (group) {
          selectuserId = '';
          setState(() {
            groupSelect = group;
          });
        });
    searchUser = SearchUser(
      onSelectValue: (user) => setState(() {
        selectuserId = user;
        print(selectuserId);
      }),
      companyId: widget.project.companyId,
      selectuserId: selectuserId,
      groupSelect: groupSelect,
    );
    nameFocus.addListener(() {
      if (!nameFocus.hasFocus) {
        setState(() {});
      }
    });
  }

  setStateSearch() {
    searchUser = SearchUser(
      onSelectValue: (user) => setState(() {
        selectuserId = user;
        print(selectuserId);
      }),
      companyId: widget.project.companyId,
      selectuserId: selectuserId,
      groupSelect: groupSelect,
    );
  }

  createmission() async {
    if (nameMission.text != "") {
      showDialog(
          context: context,
          builder: (_) => const NotifyDialog(content: "loading"));
      String missionId = const Uuid().v1();
      String res = await FirebaseMethods().createMission(
          project: widget.project,
          missionId: missionId,
          nameMission: nameMission.text,
          description: description.text,
          startDate: startDate,
          endDate: endDate,
          staffId: selectuserId);

      if (context.mounted) {
        Navigator.pop(context);
      }

      if (res == 'success') {
        if (context.mounted) {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (_) => const NotifyDialog(content: "Tạo thành công"));
        }
      } else {
        if (context.mounted) {
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
          title: const Text('Nhiem vu moi'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Center(
                    child: Text(
                  'Dự án: ${widget.project.nameProject}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                )),
                const Divider(
                  color: focusBlueColor,
                  indent: 12,
                  endIndent: 12,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 8,
                ),
                // misson name
                const Text(
                  "Tên nhiệm vụ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 4,
                ),

                // text field name mission
                TextField(
                  controller: nameMission,
                  focusNode: nameFocus,
                  style: const TextStyle(color: blackColor),
                  decoration: InputDecoration(
                    filled: true,
                    helperText: (nameMission.text != "")
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
                // description
                const Text(
                  "Mô tả",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 4,
                ),

                //text field desciption
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

                // time

                const SizedBox(
                  height: 12,
                ),

                Row(
                  children: [
                    const Text(
                      'Thời gian: ',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
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
                Row(
                  children: [
                    const Text("Nhóm: "),
                    groupDropdownButton,
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                searchUser,
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: createmission,
            tooltip: "Tạo nhiệm vụ mới",
            child: const Icon(
              Icons.add,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
