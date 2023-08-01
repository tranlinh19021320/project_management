import 'package:flutter/material.dart';
import 'package:project_management/home/admin/admin_home.dart';
import 'package:project_management/home/unit_card/notify_screen.dart';
import 'package:project_management/home/unit_card/user_profile.dart';
import 'package:provider/provider.dart';

import '../../provider/page_provider.dart';
import '../../provider/user_provider.dart';
import 'personal_screen.dart';
import '../../utils/utils.dart';

class DrawerBar extends StatefulWidget {
  const DrawerBar({
    super.key,
  });

  @override
  State<DrawerBar> createState() => _DrawerBarState();
}

class _DrawerBarState extends State<DrawerBar> {
  bool isOpenProfile = false;
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
                          ListTile(
                            selected: (context.watch<PageProvider>().page ==
                                IS_PROJECTS_PAGE),
                            selectedColor: buttonGreenColor,
                            leading: const Icon(Icons.work_rounded),
                            title: const Text(
                              "Dự án",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              context
                                  .read<PageProvider>()
                                  .changePage(IS_PROJECTS_PAGE);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AdminHomeScreen()));
                            },
                          ),
                          ListTile(
                            selected: (context.watch<PageProvider>().page ==
                                IS_PERSONAL_PAGE),
                            selectedColor: buttonGreenColor,
                            leading: const Icon(Icons.person),
                            title: const Text(
                              "Nhân sự",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              context
                                  .read<PageProvider>()
                                  .changePage(IS_PERSONAL_PAGE);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PersonalScreen()));
                            },
                          ),
                          ListTile(
                            selected: (context.watch<PageProvider>().page ==
                                IS_NOTIFY_PAGE),
                            selectedColor: buttonGreenColor,
                            leading: const Icon(Icons.notifications),
                            title: const Text(
                              "Thông báo",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              context
                                  .read<PageProvider>()
                                  .changePage(IS_NOTIFY_PAGE);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotifyScreen()));
                            },
                          ),
                          ListTile(
                            selected: (context.watch<PageProvider>().page ==
                                IS_EVENT_PAGE),
                            selectedColor: buttonGreenColor,
                            leading: const Icon(Icons.event),
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
