import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/missions/mission.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/notification.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatefulWidget {
  final DocumentSnapshot doc;
  const NotificationCard({super.key, required this.doc});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isFocus = false;
  late bool isManager;

  var notify;
  late int type = widget.doc['type'];
  bool isRead = false;

  @override
  void initState() {
    super.initState();
    isRead = widget.doc['isRead'];
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;

    notify = Notify.getNotify(doc: widget.doc, type: type);
    switch (type) {
      case TIME_KEEPING:
        notify as TimekeepingStaffNotify;
        break;
      case MISSION_IS_DELETED || MISSION_CHANGE_STAFF:
        notify as DeleteChangeMissionStaffNotify;
        break;
      case STAFF_COMPLETE_MISSION:
        notify as StaffCompleteMissionManagerNotify;
        break;
      case STAFF_RECIEVE_MISSION ||
            STAFF_RECIEVE_MISSION_FROM_OTHER ||
            MISSION_IS_CHANGED ||
            MANAGER_APPROVE_PROGRESS ||
            MISSION_IS_OPEN:
        notify as MissionNotify;
        break;
      case INVITE_REPORT:
        notify as InviteReportNotify;
        break;
    }
  }

  navigaToMission() async {
    setState(() {});
    showNotify(context: context, isLoading: true);
    String res = 'error';
    DocumentSnapshot<Map<String, dynamic>> snap;
    Mission? mission;
    try {
      snap = await FirebaseFirestore.instance
          .collection('missions')
          .doc((notify).missionId)
          .get();
      if (!isRead) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(notify.userId)
            .collection('notifications')
            .doc(notify.notifyId)
            .update({
          'isRead': true,
        });
        setState(() {
          isRead = true;
        });
      }
      if (snap.exists) {
        mission = Mission.fromSnap(doc: snap);
      }
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    if (res == 'success') {
      if (context.mounted) {
        (mission == null)
            ? showNotify(
                context: context,
                content: 'Nhiệm vụ đã bị xóa !',
                isError: true,
              )
            : (mission.staffId != FirebaseAuth.instance.currentUser!.uid &&
                    !isManager)
                ? showNotify(
                    context: context,
                    content: 'Bạn không còn phụ trách nhiệm vụ này!',
                    isError: true,
                  )
                : Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MissionHomeScreen(
                      mission: mission!,
                    ),
                  ));
      }
    } else {
      if (context.mounted) {
        showSnackBar(context: context, content: res, isError: true);
      }
    }
  }

  deleteNotification() async {
    bool? isdeleted = await showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.only(left: 30),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FloatingActionButton.small(
                        onPressed: null,
                        tooltip: "Xóa thông báo",
                        child: Icon(
                          Icons.delete_forever_rounded,
                          color: errorRedColor,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Xóa thông báo",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ));

    if (isdeleted != null && isdeleted) {
      if (context.mounted) {
        showNotify(context: context, isLoading: true);
      }
      String res = await FirebaseMethods().deleteNotification(notify: notify);
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (res != 'success') {
        if (context.mounted) {
          showSnackBar(context: context, content: res, isError: true);
        }
      }
    }
  }

  String description() {
    String description = notify.description;
    int maxlength = 65;
    if (description.length > maxlength) {
      description = description.substring(0, maxlength);
      description = "$description...";
    }
    description = description.replaceAll('\n', ", ");
    return description;
  }

  @override
  Widget build(BuildContext context) {
    return card(
        color: isRead ? darkblueColor : darkblueAppbarColor,
        onTap: (type == MISSION_IS_DELETED ||
                type == MISSION_CHANGE_STAFF ||
                type == TIME_KEEPING ||
                type == INVITE_REPORT)
            ? null
            : navigaToMission,
        title: RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 15),
              children: (type == INVITE_REPORT) //invite other to report
                  ? [
                      const TextSpan(text: "Bạn đã được "),
                      TextSpan(
                          text: notify.nameDetails,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: notifyIconColor)),
                      const TextSpan(text: " mời tham gia thảo luận báo cáo ' "),
                      TextSpan(
                          text: notify.nameReport,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: notifyIconColor)),
                      const TextSpan(text: " ' của anh ấy"),
                    ]
                  : (type == MISSION_IS_DELETED) //mission is deleted
                  ? [
                      const TextSpan(text: "Nhiệm vụ "),
                      TextSpan(
                          text: notify.nameMission,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: notifyIconColor)),
                      const TextSpan(text: " trong dự án "),
                      TextSpan(
                          text: notify.nameProject,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: notifyIconColor)),
                      const TextSpan(text: " mà bạn phụ trách đã bị xóa")
                    ]
                  : (type == MISSION_IS_CHANGED) // misstion is changed
                      ? [
                          const TextSpan(text: "Nhiệm vụ "),
                          TextSpan(
                              text: notify.nameMission,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: notifyIconColor)),
                          const TextSpan(text: " trong dự án "),
                          TextSpan(
                              text: notify.nameProject,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: notifyIconColor)),
                          const TextSpan(
                              text: " mà bạn phụ trách bị chỉnh sửa nội dung")
                        ]
                      : (type ==
                              STAFF_RECIEVE_MISSION_FROM_OTHER) //mission is deleted
                          ? [
                              const TextSpan(text: "Nhiệm vụ "),
                              TextSpan(
                                  text: notify.nameMission,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: notifyIconColor)),
                              const TextSpan(text: " trong dự án "),
                              TextSpan(
                                  text: notify.nameProject,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: notifyIconColor)),
                              const TextSpan(text: " đã chuyển sang cho bạn!")
                            ]
                          : (type ==
                                  MISSION_CHANGE_STAFF) // mission is change staff
                              ? [
                                  const TextSpan(text: "Nhiệm vụ "),
                                  TextSpan(
                                      text: notify.nameMission,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: notifyIconColor)),
                                  const TextSpan(text: " trong dự án "),
                                  TextSpan(
                                      text: notify.nameProject,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: notifyIconColor)),
                                  const TextSpan(
                                      text:
                                          " mà bạn phụ trách đã được chuyển cho nhân viên khác")
                                ]
                              : (type ==
                                      STAFF_RECIEVE_MISSION) // new mission for you
                                  ? [
                                      const TextSpan(
                                          text:
                                              "Bạn nhận được một nhiệm vụ mới: \n"),
                                      TextSpan(
                                          text: notify.nameMission,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: notifyIconColor)),
                                      const TextSpan(text: " - dự án "),
                                      TextSpan(
                                          text: notify.nameProject,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: notifyIconColor)),
                                    ]
                                  : (type ==
                                          MANAGER_APPROVE_PROGRESS) // manager approve progress
                                      ? [
                                          TextSpan(
                                              text: notify.nameMission,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: notifyIconColor)),
                                          const TextSpan(text: " - dự án "),
                                          TextSpan(
                                              text: notify.nameProject,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: notifyIconColor)),
                                          const TextSpan(
                                              text:
                                                  " :\nBài nộp tiến độ hôm nay đã được phê duyệt!"),
                                        ]
                                      : (type ==
                                              MISSION_IS_OPEN) // mission is open
                                          ? [
                                              TextSpan(
                                                  text: notify.nameMission,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: notifyIconColor)),
                                              const TextSpan(text: " - dự án "),
                                              TextSpan(
                                                  text: notify.nameProject,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: notifyIconColor)),
                                              const TextSpan(
                                                  text:
                                                      " :\nNhiệm vụ đã được mở lại!"),
                                            ]
                                          : (type ==
                                                  STAFF_COMPLETE_MISSION) // you complete mission
                                              ? [
                                                  TextSpan(
                                                      text: notify.nameProject,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              notifyIconColor)),
                                                  const TextSpan(text: " - "),
                                                  TextSpan(
                                                      text: notify.nameMission,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              notifyIconColor)),
                                                  const TextSpan(text: " :\n"),
                                                  TextSpan(
                                                      text: notify.nameDetails,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  const TextSpan(
                                                      text: " đã hoàn thành "),
                                                  TextSpan(
                                                      text:
                                                          '${(notify.percent * 100)}%',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (notify
                                                                    .percent <=
                                                                0.2)
                                                            ? Colors.red
                                                            : (notify.percent <=
                                                                    0.4)
                                                                ? Colors.orange
                                                                : (notify.percent <=
                                                                        0.7)
                                                                    ? Colors
                                                                        .yellow
                                                                    : Colors
                                                                        .green,
                                                      )),
                                                  TextSpan(
                                                      text:
                                                          " nhiệm vụ: \"${description()}...\""),
                                                ]
                                              : (type ==
                                                      TIME_KEEPING) // mission is open
                                                  ? [
                                                      const TextSpan(
                                                          text:
                                                              "Bạn được chấm công ngày "),
                                                      TextSpan(
                                                          text: (isToDay(
                                                                  dateString:
                                                                      notify
                                                                          .date))
                                                              ? "hôm nay"
                                                              : notify.date,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  notifyIconColor)),
                                                      const TextSpan(
                                                          text:
                                                              "\nTrạng thái: "),
                                                      TextSpan(
                                                        text: (notify.state ==
                                                                IS_COMPLETE)
                                                            ? "Hoàn thành tốt"
                                                            : "Chậm tiến độ",
                                                        style: TextStyle(
                                                            color: (notify
                                                                        .state ==
                                                                    IS_COMPLETE)
                                                                ? correctGreenColor
                                                                : textErrorRedColor),
                                                      ),
                                                    ]
                                                  : [
                                                      TextSpan(text: '$type'),
                                                    ]),
          maxLines: 4,
        ),
        subtitle: Text(
          timeDateWithNow(date: notify.createDate),
        ),
        leading: (type == MISSION_IS_DELETED)
            ? FloatingActionButton.small(
                heroTag: notify.notifyId,
                backgroundColor: focusBlueColor,
                onPressed: null,
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: notifyIconColor,
                ),
              )
            : (type == STAFF_RECIEVE_MISSION_FROM_OTHER ||
                    type == MISSION_CHANGE_STAFF ||
                    type == MISSION_IS_CHANGED )
                ? FloatingActionButton.small(
                    heroTag: notify.notifyId,
                    backgroundColor: focusBlueColor,
                    onPressed: null,
                    child: const Icon(
                      Icons.change_circle,
                      color: notifyIconColor,
                    ),
                  )
                : (type == STAFF_RECIEVE_MISSION||
                    type == INVITE_REPORT)
                    ? FloatingActionButton.small(
                        heroTag: notify.notifyId,
                        backgroundColor: focusBlueColor,
                        onPressed: null,
                        child: AnimatedTextKit(
                            repeatForever: true,
                            pause: const Duration(milliseconds: 0),
                            animatedTexts: [
                              ColorizeAnimatedText('Mới',
                                  textStyle: const TextStyle(fontSize: 12),
                                  colors: [
                                    Colors.deepOrange,
                                    Colors.white,
                                    Colors.yellow,
                                    Colors.green,
                                    Colors.blue,
                                    Colors.purple,
                                  ]),
                            ]),
                      )
                    : (type == MANAGER_APPROVE_PROGRESS ||
                            type == MISSION_IS_OPEN ||
                            type == STAFF_COMPLETE_MISSION ||
                            type == TIME_KEEPING)
                        ? FloatingActionButton.small(
                            heroTag: notify.notifyId,
                            backgroundColor: focusBlueColor,
                            onPressed: null,
                            child: loudspeakerIcon,
                          )
                        : null,
        trailing: IconButton(
            onPressed: deleteNotification, icon: const Icon(Icons.more_horiz)));
  }
}
