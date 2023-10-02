import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/missions/mission_detail.dart';
import 'package:project_management/home/progress/progress_screen.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';
import 'package:provider/provider.dart';

class MissionHomeScreen extends StatefulWidget {
  final Mission mission;
  const MissionHomeScreen({super.key, required this.mission});

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
    GroupProvider groupProvider = Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
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
                textBoxButton(
                    color: darkblueColor,
                    text: "Ok",
                    fontSize: 14,
                    
                    function: () => Navigator.of(context).pop(true)),
                textBoxButton(
                    color: errorRedColor,
                    text: "Hủy",
                    fontSize: 14,
                    
                    function: () => Navigator.of(context).pop(false)),
              ],
            ));

    if (comfirm != null && comfirm) {
      if (context.mounted) {
        showNotify(context: context, isLoading: true);
      }
      String res = await FirebaseMethods().deleteMission(
          mission: widget.mission);

      if (res == 'success') {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
          showNotify(context: context, content: "Đã xóa nhiem vu thành công!",);
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          showSnackBar(context: context, content: res, isError: true);
        }
      }
    }
  }


  onPageChanged(int pageNumber) {
    setState(() {
      page = pageNumber;
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
            (!isManager) ? Container() : IconButton(
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
            MissionDetailScreen(mission: widget.mission,),
            ProgressScreen(mission: widget.mission),
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
