import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/missions/missions_list.dart';
import 'package:project_management/home/projects/project_detail.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

class ProjectHomeScreen extends StatefulWidget {
  final Project project;
  const ProjectHomeScreen({super.key, required this.project});

  @override
  State<ProjectHomeScreen> createState() => _ProjectHomeScreenState();
}

class _ProjectHomeScreenState extends State<ProjectHomeScreen> {
  int page = 0;
  PageController pageController = PageController();
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
              backgroundColor: darkblueColor,
              
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
                    style: TextStyle(color: errorRedColor, fontSize: 14),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actionsPadding: const EdgeInsets.only(bottom: 14),
              actions: [
                textBoxButton(
                    color: errorRedColor,
                    text: "Ok",
                    fontSize: 14,
                    width: 60,
                    function: () => Navigator.of(context).pop(true)),
                textBoxButton(
                    color: darkblueAppbarColor,
                    text: "Hủy",
                    fontSize: 14,
                    width: 60,
                    function: () => Navigator.of(context).pop(false)),
              ],
            ));

    if (comfirm != null && comfirm) {
      if (context.mounted) {
        showNotify(context: context, isLoading: true);
      }
      String res = await FirebaseMethods().deleteProject(
          companyId: widget.project.companyId,
          projectId: widget.project.projectId);

      if (res == 'success') {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
          showNotify(context: context,content: "Đã xóa dự án thành công!",);
         
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
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            MissionsScreen(project: widget.project),
            ProjectDetailScreen(project: widget.project,),
            
          ],
        ),
       bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: page,
        items: [
          BottomNavigationBarItem(icon: missionIcon, label: "Nhiệm vụ",),
          BottomNavigationBarItem(icon: projectIcon, label: "Chi tiết", ),
          
        ],
        
        onTap: (page) => pageController.jumpToPage(page),
        
        ),
      ),
    );
  }
}
