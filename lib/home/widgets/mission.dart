import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/utils/mission_detail.dart';
import 'package:project_management/home/widgets/missions_screen.dart';
import 'package:project_management/home/admin/utils/project_detail.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/paths.dart';

class MissionHomeScreen extends StatefulWidget {
  final Project project;
  final Mission mission;
  const MissionHomeScreen({super.key, required this.project, required this.mission});

  @override
  State<MissionHomeScreen> createState() => _MissionHomeScreenState();
}

class _MissionHomeScreenState extends State<MissionHomeScreen> {
  int page = 0;
  PageController pageController = PageController();
  late bool isManager;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    isManager =await currentUserIsManager();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
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
                      "Bạn chắc muốn xóa nhiem vu '' ${widget.mission.nameMission} '' ?",
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
                    content: "Đã xóa nhiem vu thành công!",
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


  onPageChanged(int page) {
    setState(() {
      page = page;
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
        appBar: AppBar(
          backgroundColor: darkblueAppbarColor,
          title: const Text('Nhiệm vụ'),
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
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            MissionDetailScreen(project: widget.project,mission: widget.mission,),
            MissionsScreen(project: widget.project),
          ],
        ),
       bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: page,
        items: [
          BottomNavigationBarItem(icon: projectIcon, label: "Chi tiết", ),
          BottomNavigationBarItem(icon: missionIcon, label: "Tiến độ",),
        ],
        
        onTap: (page) => pageController.jumpToPage(page),
        
        ),
      ),
    );
  }
}
