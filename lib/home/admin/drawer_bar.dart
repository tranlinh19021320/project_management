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
                          // project select
                          ListTile(
                            tileColor: (context.watch<PageProvider>().page ==
                                IS_PROJECTS_PAGE) ? focusBlueColor : Colors.transparent,
                            shape:RoundedRectangleBorder(
                              side: BorderSide(
                                color: focusBlueColor
                              ),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: projectIcon,
                            ),
                            trailing:(context.watch<PageProvider>().page ==
                                IS_PROJECTS_PAGE) ? rightArrorIcon : null,
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
                          // personal select
                          ListTile(
                            tileColor: (context.watch<PageProvider>().page ==
                                IS_PERSONAL_PAGE) ? focusBlueColor : Colors.transparent,
                            shape:RoundedRectangleBorder(
                              side: BorderSide(
                                color: focusBlueColor
                              ),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: staffIcon,
                            ),
                            trailing:(context.watch<PageProvider>().page ==
                                IS_PERSONAL_PAGE) ? rightArrorIcon : null,
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
                          // notification select
                          ListTile(
                            tileColor: (context.watch<PageProvider>().page ==
                                IS_NOTIFY_PAGE) ? focusBlueColor : Colors.transparent,
                            shape:RoundedRectangleBorder(
                              side: BorderSide(
                                color: focusBlueColor
                              ),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: notifyIcon,
                            ),
                            trailing:(context.watch<PageProvider>().page ==
                                IS_NOTIFY_PAGE) ? rightArrorIcon : null,
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
                          //event select
                          ListTile(
                            tileColor: (context.watch<PageProvider>().page ==
                                IS_EVENT_PAGE) ? focusBlueColor : Colors.transparent,
                            shape:RoundedRectangleBorder(
                              side: BorderSide(
                                color: focusBlueColor
                              ),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: eventIcon,
                            ),
                            trailing:(context.watch<PageProvider>().page ==
                                IS_EVENT_PAGE) ? rightArrorIcon : null,
                            title: const Text(
                              "Sự kiện",
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              context
                                  .read<PageProvider>()
                                  .changePage(IS_EVENT_PAGE);
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
