import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/event_screen.dart';
import 'package:project_management/home/admin/personal_screen.dart';
import 'package:project_management/home/admin/projects_screen.dart';
import 'package:project_management/home/unit_card/notify_screen.dart';
import 'package:project_management/start_screen/login.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../utils/utils.dart';
import '../unit_card/user_profile.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({
    super.key,
  });

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int page = IS_PROJECTS_PAGE;
  bool isOpenProfile = false;
  String textAppBar = '';
  signOut() {
    FirebaseMethods().signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Login()));
  }
  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (page) {
      case IS_PERSONAL_PAGE:
        textAppBar = "Nhân sự";
        body = const PersonalScreen();
        break;
      case IS_NOTIFY_PAGE:
        textAppBar = "Thông báo";
        body = const NotifyScreen();
        break;
      case IS_EVENT_PAGE:
        textAppBar = "Sự kiện";
        body = const EventScreen();
        break;
      default:
        textAppBar = "Dự án";
        body = const ProjectsScreen();
        break;
    }
    return  Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(backgroundImage), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: darkblueAppbarColor,
          title: Text(textAppBar),
        ),
        drawer: Drawer(
          backgroundColor: blueDrawerColor,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: const Icon(
                  Icons.face,
                  size: 64,
                ),
                accountName: Text(
                    context.watch<UserProvider>().getCurrentUser.nameDetails),
                accountEmail:
                    Text(context.watch<UserProvider>().getCurrentUser.email),
                onDetailsPressed: () {
                  setState(() {
                    isOpenProfile = !isOpenProfile;
                  });
                },
              ),
              Expanded(
                  child: isOpenProfile
                      ? const ProfileScreen()
                      : Scaffold(
                          backgroundColor: Colors.transparent,
                          body: ListView(
                            padding: const EdgeInsets.only(top: 4),
                            children: [
                              // project select
                              ListTile(
                                tileColor: (page == IS_PROJECTS_PAGE)
                                    ? focusBlueColor
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: focusBlueColor),
                                    borderRadius: BorderRadius.circular(12)),
                                leading: projectIcon,
                                trailing: (page == IS_PROJECTS_PAGE)
                                    ? rightArrorIcon
                                    : null,
                                title: const Text(
                                  "Dự án",
                                  style: TextStyle(fontSize: 18),
                                ),
                                onTap: () {
                                  setState(() {
                                    page = IS_PROJECTS_PAGE;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              // personal select
                              ListTile(
                                tileColor: (page == IS_PERSONAL_PAGE)
                                    ? focusBlueColor
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: focusBlueColor),
                                    borderRadius: BorderRadius.circular(12)),
                                leading: staffIcon,
                                trailing: (page == IS_PERSONAL_PAGE)
                                    ? rightArrorIcon
                                    : null,
                                title: const Text(
                                  "Nhân sự",
                                  style: TextStyle(fontSize: 18),
                                ),
                                onTap: () {
                                  setState(() {
                                    page = IS_PERSONAL_PAGE;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              // notification select
                              ListTile(
                                tileColor: (page == IS_NOTIFY_PAGE)
                                    ? focusBlueColor
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: focusBlueColor),
                                    borderRadius: BorderRadius.circular(12)),
                                leading: notifyIcon,
                                trailing: (page == IS_NOTIFY_PAGE)
                                    ? rightArrorIcon
                                    : null,
                                title: const Text(
                                  "Thông báo",
                                  style: TextStyle(fontSize: 18),
                                ),
                                onTap: () {
                                  setState(() {
                                    page = IS_NOTIFY_PAGE;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              //event select
                              ListTile(
                                tileColor: (page == IS_EVENT_PAGE)
                                    ? focusBlueColor
                                    : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: focusBlueColor),
                                    borderRadius: BorderRadius.circular(12)),
                                leading: eventIcon,
                                trailing: (page == IS_EVENT_PAGE)
                                    ? rightArrorIcon
                                    : null,
                                title: const Text(
                                  "Sự kiện",
                                  style: TextStyle(fontSize: 18),
                                ),
                                onTap: () {
                                  setState(() {
                                    page = IS_EVENT_PAGE;
                                  });
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                          floatingActionButton: InkWell(
                            onTap: signOut,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                color: errorRedColor,
                              ),
                              width: 100,
                              height: 36,
                              child: const Center(
                                  child: Text(
                                "Đăng xuất",
                              )),
                            ),
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.endFloat,
                        )),
            ],
          ),
        ),
        body: SingleChildScrollView(child: body),
      ),
    );
  }
}
