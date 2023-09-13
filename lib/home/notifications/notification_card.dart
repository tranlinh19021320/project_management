
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/missions/mission.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/notification.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/parameters.dart';

class NotificationCard extends StatefulWidget {
  final Notify notify;
  const NotificationCard({super.key, required this.notify});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isFocus = false;

  navigaToMission() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => const NotifyDialog(content: 'loading'));
    String res = 'error';
    DocumentSnapshot<Map<String, dynamic>> snap;
    Mission? mission;
    try {
      snap = await FirebaseFirestore.instance
          .collection('missions')
          .doc(widget.notify.missionId)
          .get();
      if (snap.exists) {
        mission = Mission.fromSnap(mission: snap);
        if (!widget.notify.isRead) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.notify.userId)
              .collection('notifications')
              .doc(widget.notify.notifyId)
              .update({
            'isRead': true,
          });
        }
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
            ? showDialog(
                context: context,
                builder: (_) => const NotifyDialog(
                      content: 'Nhiệm vụ đã bị xóa !',
                      isError: true,
                    ))
            :(mission.staffId != FirebaseAuth.instance.currentUser!.uid) ?showDialog(
                context: context,
                builder: (_) => const NotifyDialog(
                      content: 'Bạn không còn phụ trách nhiệm vụ này!',
                      isError: true,
                    )) : Navigator.of(context).push(MaterialPageRoute(
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
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => const NotifyDialog(content: 'loading'));
      }
      String res =
          await FirebaseMethods().deleteNotification(notify: widget.notify);
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
    String description = widget.notify.description;
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
    return Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: focusBlueColor),
            borderRadius: BorderRadius.circular(6),
            color: (widget.notify.isRead)
                ? Colors.transparent
                : darkblueAppbarColor,
          ),
          padding: const EdgeInsets.all(4),
          width: MediaQuery.of(context).size.width * 0.98,
          child: ListTile(
            onFocusChange: (value) => setState(() {
              isFocus = value;
            }),
            onTap: (widget.notify.type == MISSION_IS_DELETED
            || widget.notify.type == MISSION_CHANGE_STAFF)
                ? null
                : navigaToMission,
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            isThreeLine: true,
            leading: (widget.notify.type == MISSION_IS_DELETED)
                ? FloatingActionButton.small(
                    heroTag: widget.notify.notifyId,
                    backgroundColor: focusBlueColor,
                    onPressed: null,
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: notifyIconColor,
                    ),
                  )
                : (widget.notify.type == STAFF_RECIEVE_MISSION_FROM_OTHER
                || widget.notify.type == MISSION_CHANGE_STAFF
                || widget.notify.type == MISSION_IS_CHANGED)
                    ? FloatingActionButton.small(
                        heroTag: widget.notify.notifyId,
                        backgroundColor: focusBlueColor,
                        onPressed: null,
                        child: const Icon(
                          Icons.change_circle,
                          color: notifyIconColor,
                        ),
                      )
                    : (widget.notify.type == STAFF_RECIEVE_MISSION )
                        ? FloatingActionButton.small(
                            heroTag: widget.notify.notifyId,
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
                        : (widget.notify.type == MANAGER_APPROVE_PROGRESS ||
                                widget.notify.type == MISSION_IS_OPEN || widget.notify.type == STAFF_COMPLETE_MISSION)
                            ? FloatingActionButton.small(
                                heroTag: widget.notify.notifyId,
                                backgroundColor: focusBlueColor,
                                onPressed: null,
                                child: loudspeakerIcon,
                              )
                            : null,
            title: RichText(
              text: TextSpan(
                  style: const TextStyle(fontSize: 15),
                  children: (widget.notify.type == MISSION_IS_DELETED) //mission is deleted
                      ? [
                          const TextSpan(text: "Nhiệm vụ "),
                          TextSpan(
                              text: widget.notify.nameMission,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: notifyIconColor)),
                          const TextSpan(text: " trong dự án "),
                          TextSpan(
                              text: widget.notify.nameProject,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: notifyIconColor)),
                          const TextSpan(text: " mà bạn phụ trách đã bị xóa")
                        ]
                      : (widget.notify.type == MISSION_IS_CHANGED) // misstion is changed
                      ? [
                          const TextSpan(text: "Nhiệm vụ "),
                          TextSpan(
                              text: widget.notify.nameMission,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: notifyIconColor)),
                          const TextSpan(text: " trong dự án "),
                          TextSpan(
                              text: widget.notify.nameProject,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: notifyIconColor)),
                          const TextSpan(text: " mà bạn phụ trách bị chỉnh sửa nội dung")
                        ]
                      :(widget.notify.type == STAFF_RECIEVE_MISSION_FROM_OTHER) //mission is deleted
                      ? [
                          const TextSpan(text: "Nhiệm vụ "),
                          TextSpan(
                              text: widget.notify.nameMission,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: notifyIconColor)),
                          const TextSpan(text: " trong dự án "),
                          TextSpan(
                              text: widget.notify.nameProject,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: notifyIconColor)),
                          const TextSpan(text: " đã chuyển sang cho bạn!")
                        ]
                      :  (widget.notify.type == MISSION_CHANGE_STAFF) // mission is change staff
                          ? [
                              const TextSpan(text: "Nhiệm vụ "),
                              TextSpan(
                                  text: widget.notify.nameMission,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: notifyIconColor)),
                              const TextSpan(text: " trong dự án "),
                              TextSpan(
                                  text: widget.notify.nameProject,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: notifyIconColor)),
                              const TextSpan(
                                  text: " mà bạn phụ trách đã được chuyển cho nhân viên khác")
                            ]
                          : (widget.notify.type == STAFF_RECIEVE_MISSION) // new mission for you
                              ? [
                                  const TextSpan(
                                      text:
                                          "Bạn nhận được một nhiệm vụ mới: \n"),
                                  TextSpan(
                                      text: widget.notify.nameMission,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: notifyIconColor)),
                                  const TextSpan(text: " - dự án "),
                                  TextSpan(
                                      text: widget.notify.nameProject,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: notifyIconColor)),
                                ]
                              : (widget.notify.type == MANAGER_APPROVE_PROGRESS) // manager approve progress
                                  ? [
                                      TextSpan(
                                          text: widget.notify.nameMission,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: notifyIconColor)),
                                      const TextSpan(text: " - dự án "),
                                      TextSpan(
                                          text: widget.notify.nameProject,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: notifyIconColor)),
                                      const TextSpan(
                                          text:
                                              " :\nBài nộp tiến độ hôm nay đã được phê duyệt!"),
                                    ]
                                  : (widget.notify.type == MISSION_IS_OPEN) // mission is open
                                      ? [
                                          TextSpan(
                                              text: widget.notify.nameMission,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: notifyIconColor)),
                                          const TextSpan(text: " - dự án "),
                                          TextSpan(
                                              text: widget.notify.nameProject,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: notifyIconColor)),
                                          const TextSpan(
                                              text:
                                                  " :\nNhiệm vụ đã được mở lại!"),
                                        ]
                                      : (widget.notify.type ==
                                              STAFF_COMPLETE_MISSION) // you complete mission
                                          ? [
                                              TextSpan(
                                                  text:
                                                      widget.notify.nameProject,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: notifyIconColor)),
                                              const TextSpan(text: " - "),
                                              TextSpan(
                                                  text:
                                                      widget.notify.nameMission,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: notifyIconColor)),
                                              const TextSpan(text: " :\n"),
                                              TextSpan(
                                                  text: widget.notify.username,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      )),
                                              const TextSpan(
                                                  text:
                                                      " đã hoàn thành "),
                                              TextSpan(
                                                  text:
                                                      '${(widget.notify.percent * 100)}%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: (widget.notify.percent <=0.2)
                                                        ? Colors.red
                                                        : (widget.notify.percent <=0.4)
                                                            ? Colors.orange
                                                            : (widget.notify.percent <=0.7)
                                                                ? Colors.yellow
                                                                : Colors.green,
                                                  )),
                                                  TextSpan(
                                                  text:
                                                      " nhiệm vụ: \"${description()}...\""),
                                            ]
                                          : [
                                            TextSpan(text: '${widget.notify.type}'),
                                          ]),
              maxLines: 4,
            ),
            subtitle: Text(timeDateWithNow(date: widget.notify.createDate)),
            trailing: IconButton(
                onPressed: deleteNotification,
                icon: const Icon(Icons.more_horiz)),
          ),
        )
      ],
    );
  }
}
