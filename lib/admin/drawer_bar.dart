import 'package:flutter/material.dart';
import 'package:project_management/admin/admin_home.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/unit_card/notify_screen.dart';
import 'package:project_management/unit_card/user_profile.dart';

import 'personal_screen.dart';
import '../stateparams/utils.dart';

class DrawerBar extends StatefulWidget {
  final int page;
  final String userId;
  const DrawerBar({super.key, required this.page, required this.userId,});

  @override
  State<DrawerBar> createState() => _DrawerBarState();
}

class _DrawerBarState extends State<DrawerBar> {
  bool isOpenProfile = false;
  late CurrentUser currentUser;
  
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }
  
  getCurrentUser() async {
    currentUser = await FirebaseMethods().getCurrentUserByUserId(widget.userId);
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
            accountName: Text(currentUser.nameDetails),
            accountEmail: Text(currentUser.email),
            onDetailsPressed: () {
              setState(() {
                isOpenProfile = !isOpenProfile;
              });
            },
          ),
          Expanded(
              child: isOpenProfile
                  ? ProfileScreen(userId: widget.userId,)
                  : Scaffold(
                      backgroundColor: Colors.transparent,
                      body: ListView(
                        padding: const EdgeInsets.only(top: 4),
                        children: [
                          ListTile(
                            selected: (widget.page == IS_PROJECTS_PAGE),
                            selectedColor: buttonGreenColor,
                            leading: Icon(Icons.work_rounded),
                            title: const Text(
                              "Dự án",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => AdminHomeScreen(
                                        userId: widget.userId))),
                          ),
                          ListTile(
                            selected: (widget.page == IS_PERSONAL_PAGE),
                            selectedColor: buttonGreenColor,
                            leading: const Icon(Icons.person),
                            title: const  Text(
                              "Nhân sự",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => PersonalScreen(
                                        userId: widget.userId))),
                          ),
                          ListTile(
                            selected: (widget.page == IS_NOTIFY_PAGE),
                            selectedColor: buttonGreenColor,
                            leading: const Icon(Icons.notifications),
                            title: const Text(
                              "Thông báo",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => NotifyScreen(
                                        userId: widget.userId))),
                          ),
                          ListTile(
                            selected: (widget.page == IS_EVENT_PAGE),
                            selectedColor: buttonGreenColor,
                            leading:const  Icon(Icons.event),
                            title: const Text(
                              "Sự kiện",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              setState(() {});
                            },
                          )
                        ],
                      ),
                      floatingActionButton: InkWell(
                        onTap: () {},
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
    );
  }
}
