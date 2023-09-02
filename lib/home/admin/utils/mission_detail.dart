import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/group_dropdown_button.dart';
import 'package:project_management/home/widgets/search_user.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';
import 'package:uuid/uuid.dart';

class MissionDetailScreen extends StatefulWidget {
  final Project project;
  final Mission? mission;
  const MissionDetailScreen({super.key, required this.project, this.mission});

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> {
  TextEditingController nameMission = TextEditingController();
  TextEditingController description = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  ScrollController descriptionScroll = ScrollController();

  late DateTime startDate;
  late DateTime endDate;

  String selectuserId = '';

  String groupSelect = "Tất cả";

  int missionState = IS_DEFAULT_STATE;

  late GroupDropdownButton groupDropdownButton;
  late SearchUser searchUser;

  double percent = 0;

  @override
  void initState() {
    super.initState();

    nameFocus.addListener(() {
      if (!nameFocus.hasFocus) {
        updateMissionState();
        setState(() {});
      } else {
        setState(() {
          missionState = IS_DEFAULT_STATE;
        });
      }
    });

    DateTime now = DateTime.now();
    startDate = (now.isBefore(widget.project.startDate))
        ? widget.project.startDate
        : now;
    endDate = startDate;
    if (widget.mission != null) {
      nameMission.text = widget.mission!.nameMission;
      description.text = widget.mission!.description;
      startDate = widget.mission!.startDate;
      endDate = widget.mission!.endDate;
      selectuserId = widget.mission!.staffId;
      percent = widget.mission!.percent;
    }

    groupDropdownButton = GroupDropdownButton(
        companyId: widget.project.companyId,
        groupSelect: groupSelect,
        isWordAtHead: "Tất cả",
        onSelectValue: (group) {
          selectuserId = '';
          setState(() {
            groupSelect = group;
            refreshSearchUser();
          });
        });

    refreshSearchUser();
  }

  refreshSearchUser() {
    searchUser = SearchUser(
      companyId: widget.project.companyId,
      groupSelect: groupSelect,
      selectuserId: selectuserId,
      onSelectValue: (value) {
        setState(() {
          selectuserId = value;
          print(selectuserId);
        });
      },
    );
  }

  updateMissionState() async {
    setState(() {
      missionState = IS_ERROR_FORMAT_STATE;
    });
    var snap = await FirebaseFirestore.instance
        .collection('missions')
        .where('companyId', isEqualTo: widget.project.companyId)
        .where('projectId', isEqualTo: widget.project.projectId)
        .where('nameMission', isEqualTo: nameMission.text)
        .get();

    if (snap.docs.isNotEmpty) {
      setState(() {
        missionState = IS_ERROR_STATE;
      });
    } else {
      setState(() {
        missionState = IS_CORRECT_STATE;
      });
    }
    if (nameMission.text == '') {
      setState(() {
        IS_DEFAULT_STATE;
      });
    }
  }

  createmission() async {
    if (nameMission.text != "" && missionState == IS_CORRECT_STATE) {
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
                      helperText: (missionState == IS_DEFAULT_STATE)
                          ? 'Vui lòng điền tên nhiệm vụ!'
                          : (missionState == IS_ERROR_STATE)
                              ? "Tên nhiệm vụ trùng lặp"
                              : (missionState == IS_ERROR_FORMAT_STATE)
                                  ? "..."
                                  : "",
                      helperStyle: TextStyle(
                          color: (missionState == IS_ERROR_STATE)
                              ? errorRedColor
                              : defaultColor),
                      suffixIcon: (missionState != IS_CORRECT_STATE)
                          ? null
                          : const Icon(
                              Icons.check,
                              color: correctGreenColor,
                            ),
                      fillColor: backgroundWhiteColor,
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(descriptionFocus);
                    }),
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
                // StreamBuilder(
                //     stream: FirebaseMethods()
                //         .searchSnapshot(groupSelect: groupSelect),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return LoadingAnimationWidget.hexagonDots(
                //             color: darkblueAppbarColor, size: 20);
                //       }
                //       List<String> usersId = [''];
                //       Map<String, CurrentUser> users = {};
                //       for (DocumentSnapshot doc in snapshot.data!.docs) {
                //         usersId.add(doc['userId']);
                //         users.addAll(
                //             {doc['userId']: CurrentUser.fromSnap(user: doc)});
                //       }
                //       return Container(
                //         height: 50,
                //         child: DropdownButtonHideUnderline(
                //           child: DropdownButton(
                //             itemHeight: kMinInteractiveDimension,
                //             padding: EdgeInsets.zero,
                //             menuMaxHeight: 200,
                //             // alignment: Alignment.center,
                //             value: selectuserId,
                //             style: const TextStyle(
                //               fontSize: 13,
                //             ),
                //             isExpanded: true,
                //             // isDense: true,

                //             items: usersId.map((String value) {
                //               return DropdownMenuItem<String>(
                //                 value: value,
                //                 child: Container(
                //                   height: 50,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(8),
                //                     border: Border.all(color: focusBlueColor),
                //                     color: (value == selectuserId && value != '')
                //                         ? focusBlueColor
                //                         : Colors.transparent,
                //                   ),
                //                   child: (value == "")
                //                       ? const Center(
                //                           child: Text(
                //                             'Trống',
                //                             style:
                //                                 TextStyle(color: defaultColor),
                //                           ),
                //                         )
                //                       : ListTile(
                //                           contentPadding:
                //                               const EdgeInsets.symmetric(
                //                                   horizontal: 12),
                //                           dense: true,
                //                           visualDensity: const VisualDensity(
                //                               horizontal: -4, vertical: -4),
                //                           leading: CircleAvatar(
                //                             backgroundImage: NetworkImage(
                //                                 users[value]!.photoURL),
                //                             radius: 20,
                //                           ),
                //                           title: Text(
                //                             users[value]!.nameDetails,
                //                             style:
                //                                 const TextStyle(fontSize: 16),
                //                           ),
                //                           subtitle: Text(users[value]!.group),
                //                           trailing:
                //                               (users[value]!.group == manager)
                //                                   ? resizedIcon(keyImage, 18)
                //                                   : resizedIcon(staffImage, 18),
                //                         ),
                //                 ),
                //               );
                //             }).toList(),
                //             onChanged: (val) {
                //               setState(() {
                //                 selectuserId = val!;
                //               });
                //             },
                //           ),
                //         ),
                //       );
                //     }),
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
