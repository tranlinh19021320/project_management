import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/progress/progress_card.dart';
import 'package:project_management/home/progress/progress_detail.dart';
import 'package:project_management/home/projects/project_detail.dart';
import 'package:project_management/home/widgets/group_dropdown_button.dart';
import 'package:project_management/home/widgets/search_user.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/progress.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MissionDetailScreen extends StatefulWidget {
  final Project? project;
  final Mission? mission;
  const MissionDetailScreen({super.key, this.project, this.mission});

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
  late bool isManager;
  String selectuserId = '';
  late String companyId;
  late String projectId;
  late String nameProject;
  String groupSelect = "Tất cả";

  int missionState = IS_DEFAULT_STATE;

  late GroupDropdownButton groupDropdownButton;
  late SearchUser searchUser;

  double percent = 0;
  bool isMissionTime = false;
  bool isLoadingProject = false;

  @override
  void initState() {
    super.initState();
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
    nameFocus.addListener(() {
      if (isManager) {
        if (!nameFocus.hasFocus) {
          updateMissionState();
          setState(() {});
        } else {
          setState(() {
            missionState = IS_DEFAULT_STATE;
          });
        }
      }
    });

    if (widget.project != null) {
      nameProject = widget.project!.nameProject;
      companyId = widget.project!.companyId;
      projectId = widget.project!.projectId;
      DateTime now = DateTime.now();
      startDate = (now.isBefore(widget.project!.startDate))
          ? widget.project!.startDate
          : now;
      endDate = startDate;
    }
    if (widget.mission != null) {
      nameProject = widget.mission!.nameProject;
      companyId = widget.mission!.companyId;
      projectId = widget.mission!.projectId;
      nameMission.text = widget.mission!.nameMission;
      description.text = widget.mission!.description;
      startDate = widget.mission!.startDate;
      endDate = widget.mission!.endDate;
      selectuserId = widget.mission!.staffId;
      percent = widget.mission!.percent;
      missionState = IS_CORRECT_STATE;
      isMissionTime =
          startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now());
    }

    groupDropdownButton = GroupDropdownButton(
        companyId: companyId,
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
      companyId: companyId,
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
        .where(
          'companyId',
          isEqualTo: companyId,
        )
        .where(
          'projectId',
          isEqualTo: projectId,
        )
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
      showNotify(context: context, isLoading: true);
      String missionId = const Uuid().v1();
      String res = await FirebaseMethods().createMission(
          project: widget.project!,
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
          showNotify(context: context, content: "Tạo thành công");
          
        }
      } else {
        if (context.mounted) {
          showSnackBar(context: context, content: res, isError: true);
        }
      }
    }
  }

  bool ischanged() {
    return (nameMission.text != widget.mission!.nameMission ||
        description.text != widget.mission!.description ||
        selectuserId != widget.mission!.staffId ||
        !startDate.isAtSameMomentAs(widget.mission!.startDate) ||
        !endDate.isAtSameMomentAs(widget.mission!.endDate));
  }

  updateMission() async {
    if (ischanged()) {
      showNotify(context: context, isLoading: true);
      String res = await FirebaseMethods().updateMission(
          mission: widget.mission!,
          nameMission: nameMission.text,
          description: description.text,
          staffId: selectuserId,
          startDate: startDate,
          endDate: endDate);
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (res == 'success') {
        if (context.mounted) {
          showNotify(context: context, content: 'Cập nhật thành công!');
          
        }
      } else {
        if (context.mounted) {
          showSnackBar(context: context, content: res, isError: true);
        }
      }
    }
  }

  navigaToProject() async {
    setState(() {
      isLoadingProject = true;
    });
    var snap = await FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .collection('projects')
        .doc(projectId)
        .get();

    Project project = Project.fromSnap(snap);
    if (context.mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgroundImage), fit: BoxFit.fill),
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: const Text("Dự án"),
                    centerTitle: true,
                    backgroundColor: darkblueAppbarColor,
                  ),
                  body: ProjectDetailScreen(
                    project: project,
                  ),
                ),
              )));
    }
    setState(() {
      isLoadingProject = false;
    });
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
        body: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Center(
                    child: InkWell(
                  onTap: isManager ? () {} : navigaToProject,
                  child: Text(
                    'Dự án: $nameProject',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                )),
                (isLoadingProject)
                    ? const LinearProgressIndicator(
                        color: correctGreenColor,
                        semanticsLabel: "Đang chuyển sang dự án",
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      )
                    : const Divider(
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
                      helperText: (!isManager)
                          ? ""
                          : (missionState == IS_DEFAULT_STATE)
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
                      fillColor:
                          (!isManager) ? defaultColor : backgroundWhiteColor,
                    ),
                    readOnly: !isManager,
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
                  decoration: InputDecoration(
                    filled: true,
                    helperText: "",
                    fillColor:
                        (!isManager) ? defaultColor : backgroundWhiteColor,
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  scrollController: descriptionScroll,
                  readOnly: !isManager,
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
                      onTap: (!isManager)
                          ? () {}
                          : () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: startDate,
                                firstDate: (widget.project != null)
                                    ? widget.project!.startDate
                                    :(startDate.isBefore(DateTime.now())) ? startDate : DateTime.now(),
                                lastDate: (widget.project != null)
                                    ? widget.project!.endDate
                                    : DateTime(DateTime.now().year + 10),
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
                      onTap: (!isManager)
                          ? () {}
                          : () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: endDate,
                                firstDate: startDate,
                                lastDate: (widget.project != null)
                                    ? widget.project!.endDate
                                    : DateTime(DateTime.now().year + 10),
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
                const Divider(
                  height: 5,
                  thickness: 2,
                ),
                (!isManager)
                    ? Container()
                    : Row(
                        children: [
                          const Text("Nhóm: "),
                          groupDropdownButton,
                        ],
                      ),
                const SizedBox(
                  height: 8,
                ),
                (!isManager) ? Container() : searchUser,
                const SizedBox(
                  height: 8,
                ),
                (widget.mission == null)
                    ? Container()
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          children: [
                            const Center(
                              child: Text(
                                'Tiến độ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: circularPercentIndicator(
                                  percent: widget.mission!.percent,
                                  radius: 60,
                                  fontSize: 20,
                                  lineWidth: 30),
                            ),
                            const Divider(),
                            const Text("Hoàn thành hôm nay"),
                            const SizedBox(
                              height: 8,
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('missions')
                                    .doc(widget.mission!.missionId)
                                    .collection('progress')
                                    .where('date',
                                        isEqualTo:
                                            dayToString(time: DateTime.now()))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return LoadingAnimationWidget.inkDrop(
                                        color: darkblueAppbarColor, size: 32);
                                  }
                    
                                  if (snapshot.data!.docs.isEmpty) {
                                    return InkWell(
                                      onTap: (isManager || !isMissionTime)
                                          ? () {}
                                          : () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ProgressDetailScreen(
                                                        mission: widget.mission,
                                                      ))),
                                      child: DottedBorder(
                                          color: defaultColor,
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Center(
                                              child: (!isMissionTime)
                                                  ? const Text(
                                                      "Không trong thời gian nhiệm vụ!")
                                                  : (isManager)
                                                      ? const Text(
                                                          "Chưa có hoàn thành hôm nay")
                                                      : const Icon(Icons.add))),
                                    );
                                  }
                    
                                  return ProgressCard(
                                      progress: Progress.fromSnap(
                                          doc: snapshot.data!.docs.first));
                                })
                          ],
                        ),
                    ),

                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: (!isManager)
            ? null
            : (widget.mission != null)
                ? FloatingActionButton(
                    heroTag: "updateMissionButton",
                    onPressed: updateMission,
                    tooltip: "Cập nhật nhiệm vụ",
                    child: const Icon(
                      Icons.update,
                    ))
                : FloatingActionButton(
                    heroTag: "createMissionButton",
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
