import 'package:flutter/material.dart';
import 'package:project_management/home/admin/event_screen.dart';
import 'package:project_management/home/admin/personal_screen.dart';
import 'package:project_management/home/admin/projects_screen.dart';
import 'package:project_management/home/staff/staff_home.dart';
import 'package:project_management/home/admin/notify_screen.dart';
import 'package:provider/provider.dart';

import '../../firebase/firebase_methods.dart';
import '../../provider/user_provider.dart';
import '../../start_screen/login.dart';
import '../../utils/utils.dart';
import '../unit_card/user_profile.dart';

class DrawerMenu extends StatefulWidget {
  final int selectedPage;
  const DrawerMenu({super.key, required this.selectedPage});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool isOpenProfile = false;
  

  signOut() {
    FirebaseMethods().signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: blueDrawerColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const Icon(
              Icons.face,
              size: 64,
            ),
            accountName:
                Text(context.watch<UserProvider>().getCurrentUser.nameDetails),
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
                            tileColor: (widget.selectedPage == IS_PROJECTS_PAGE)
                                ? focusBlueColor
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: focusBlueColor),
                                borderRadius: BorderRadius.circular(12)),
                            leading: projectIcon,
                            trailing: (widget.selectedPage == IS_PROJECTS_PAGE)
                                ? rightArrorIcon
                                : null,
                            title: const Text(
                              "Dự án",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProjectsScreen()));
                            },
                          ),
                          // personal select
                          ListTile(
                            tileColor: (widget.selectedPage == IS_PERSONAL_PAGE)
                                ? focusBlueColor
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: focusBlueColor),
                                borderRadius: BorderRadius.circular(12)),
                            leading: staffIcon,
                            trailing: (widget.selectedPage == IS_PERSONAL_PAGE)
                                ? rightArrorIcon
                                : null,
                            title: const Text(
                              "Nhân sự",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const PersonalScreen()));
                            },
                          ),
                          // notification select
                          ListTile(
                            tileColor: (widget.selectedPage == IS_NOTIFY_PAGE)
                                ? focusBlueColor
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: focusBlueColor),
                                borderRadius: BorderRadius.circular(12)),
                            leading: notifyIcon(0),
                            trailing: (widget.selectedPage == IS_NOTIFY_PAGE)
                                ? rightArrorIcon
                                : null,
                            title: const Text(
                              "Thông báo",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const NotifyScreen()));
                            },
                          ),
                          //event select
                          ListTile(
                            tileColor: (widget.selectedPage == IS_EVENT_PAGE)
                                ? focusBlueColor
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: focusBlueColor),
                                borderRadius: BorderRadius.circular(12)),
                            leading: eventIcon,
                            trailing:
                                (widget.selectedPage == IS_EVENT_PAGE) ? rightArrorIcon : null,
                            title: const Text(
                              "Sự kiện",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const EventScreen()));
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
                          width: 80,
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
    );
  }
}