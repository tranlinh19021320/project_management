import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/home/admin/screens/event_screen.dart';
import 'package:project_management/home/admin/screens/personal_screen.dart';
import 'package:project_management/home/admin/screens/projects_screen.dart';
import 'package:project_management/home/admin/screens/notify_screen.dart';
import 'package:provider/provider.dart';

import '../../../firebase/firebase_methods.dart';
import '../../../provider/user_provider.dart';
import '../../../start_screen/login.dart';
import '../../../utils/utils.dart';
import '../../unit_card/user_profile.dart';

class DrawerMenu extends StatefulWidget {
  final int selectedPage;
  const DrawerMenu({super.key, required this.selectedPage});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool isOpenProfile = false;
  bool isLoadingImage = false;
  

  signOut() {
    FirebaseMethods().signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const Login()));
  }

  selectImage() async {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              backgroundColor: darkblueAppbarColor,
              title: const Text("Chọn ảnh"),
              surfaceTintColor: correctGreenColor,
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.all(18),
                  child: const Text("Camera"),
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      isLoadingImage = true;
                    });
                    Uint8List imageFile =
                        await pickImage(context, ImageSource.camera);

                    changeProfileImage(imageFile);
                    setState(() {
                      isLoadingImage = false;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(18),
                  child: const Text("Thư viện ảnh"),
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      isLoadingImage = true;
                    });
                    Uint8List imageFile =
                        await pickImage(context, ImageSource.gallery);
                    changeProfileImage(imageFile);
                    setState(() {
                      isLoadingImage = false;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(18),
                  child: const Text(
                    "Hủy",
                    style: TextStyle(color: errorRedColor),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  changeProfileImage(Uint8List image) {
      context.read<UserProvider>().changeImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: blueDrawerColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Stack(
              children: [
                InkWell(
                  onTap: () {
                    (isOpenProfile) ? selectImage() : null;
                  },
                  child: (isLoadingImage)
                      ? CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.transparent,
                          child: LoadingAnimationWidget.discreteCircle(
                              color: backgroundWhiteColor, size: 24),
                        )
                      : CircleAvatar(
                          backgroundColor: backgroundWhiteColor,
                          backgroundImage: NetworkImage(context
                              .watch<UserProvider>()
                              .getCurrentUser
                              .photoURL),
                          radius: 64,
                        ),
                ),
                (isOpenProfile)
                    ? Positioned(
                        bottom: -15,
                        left: 35,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 18,
                          ),
                          color: backgroundWhiteColor,
                        ),
                      )
                    : Container(),
              ],
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
                                ? rightArrowPageIcon
                                : null,
                            title: const Text(
                              "Dự án",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const ProjectsScreen()));
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
                            leading: resizedIcon(staffImage, 30),
                            trailing: (widget.selectedPage == IS_PERSONAL_PAGE)
                                ? rightArrowPageIcon
                                : null,
                            title: const Text(
                              "Nhân sự",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const PersonalScreen()));
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
                                ? rightArrowPageIcon
                                : null,
                            title: const Text(
                              "Thông báo",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const NotifyScreen()));
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
                            trailing: (widget.selectedPage == IS_EVENT_PAGE)
                                ? rightArrowPageIcon
                                : null,
                            title: const Text(
                              "Sự kiện",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const EventScreen()));
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
