import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/missions/mission_detail.dart';
import 'package:project_management/home/widgets/missions/missions_list.dart';
import 'package:project_management/home/widgets/project_titles/title_content.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/model/title.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

class TitleCard extends StatefulWidget {
  final Project project;
  final TitleProject title;
  final int index;
  const TitleCard(
      {super.key,
      required this.title,
      required this.index,
      required this.project});

  @override
  State<TitleCard> createState() => _TitleCardState();
}

class _TitleCardState extends State<TitleCard> {
  bool isOpen = false;
  bool todayInTitle = false;
  @override
  void initState() {
    super.initState();
    todayInTitle = dateInTime(
        startDate: widget.title.startDate, endDate: widget.title.endDate);
    isOpen = todayInTitle;
  }

  createNewMission() => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.fill),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: darkblueAppbarColor,
                title: const Text('Nhiệm vụ mới'),
                centerTitle: true,
              ),
              body: MissionDetailScreen(
                project: widget.project,
                title: widget.title,
              ),
            ),
          )));
  delete() async {
    bool comfirm = false;
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              scrollable: true,
              title: Column(
                children: [
                  Text(
                      "Bạn chắc muốn xóa tiêu đề '' ${widget.title.title} '' ?",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Tiêu đề sẽ bị xóa vĩnh viễn!",
                    style: TextStyle(color: errorRedColor, fontSize: 14),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.all(4),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actionsPadding: const EdgeInsets.only(bottom: 14),
              actions: [
                textBoxButton(
                  color: errorRedColor,
                  text: "Ok",
                  width: 60,
                  fontSize: 14,
                  function: () {
                    comfirm = true;
                    Navigator.pop(context);
                  },
                ),
                textBoxButton(
                    color: darkblueAppbarColor,
                    text: "Hủy",
                    width: 60,
                    fontSize: 14,
                    function: () => Navigator.of(context).pop()),
              ],
            ));

    if (comfirm) {
      String res =
          await FirebaseMethods().deleteTitle(titleProject: widget.title);

      if (res == 'success') {
        if (mounted) {
          showNotify(
            context: context,
            content: "Đã xóa thành công!",
          );
        }
      } else {
        if (mounted) {
          showSnackBar(context: context, content: res, isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        card(
            color: todayInTitle ? darkblueAppbarColor : darkblueColor,
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(seconds: 2),
                        transitionBuilder: ((child, animation) =>
                            RotationTransition(
                              turns: isOpen
                                  ? Tween<double>(begin: 0.25, end: 0.5)
                                      .animate(animation)
                                  : Tween<double>(begin: 0.5, end: 0.25)
                                      .animate(animation),
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            )),
                        child: const Icon(Icons.arrow_drop_up_sharp),
                      ),
                      Text(
                        '${widget.index + 1}. ${widget.title.title}',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () => showDialog(
                              context: context,
                              builder: (_) => TitleContent(
                                    title: widget.title,
                                  )),
                          child: resizedIcon(createImagePath, size: 15))
                    ],
                  ),
                ),
                const Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: backgroundWhiteColor,
                ),
                Text("Nhiệm vụ: ${widget.title.missions}")
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.title.missions == 0)
                    ? const Text("--/--/---- - --/--/----")
                    : Text(
                        "${DateFormat('dd/MM/yyyy').format(
                          widget.title.startDate,
                        )} - ${DateFormat('dd/MM/yyyy').format(
                          widget.title.endDate,
                        )} (${widget.title.endDate.difference(widget.title.startDate).inDays + 1} ngày) ",
                        style: const TextStyle(fontSize: 13),
                      ),
                textBoxButton(
                  color: buttonGreenColor,
                  text: "Tạo nhiệm vụ",
                  width: 90,
                  height: 25,
                  padding: 4,
                  radius: 6,
                  function: createNewMission,
                )
              ],
            ),
            trailing: (widget.title.missions != 0)
                ? null
                : InkWell(
                    onTap: delete,
                    child: const Icon(
                      Icons.delete_forever,
                      color: defaultColor,
                      size: 20,
                    ),
                  )),
        !isOpen
            ? Container()
            : MissionsScreen(
                project: widget.project,
                titleProject: widget.title,
              )
      ],
    );
  }
}
