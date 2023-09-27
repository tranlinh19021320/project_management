import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/home/staff/screens/staff_time_keeping.dart';
import 'package:project_management/home/staff/screens/staff_home.dart';
import 'package:project_management/home/staff/screens/staff_notify_screen.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/parameters.dart';
import '../../../firebase/firebase_methods.dart';
import '../../../start_screen/login.dart';
import '../../widgets/user_profile.dart';

class StaffDrawerMenu extends StatefulWidget {
  final int selectedPage;
  const StaffDrawerMenu({
    super.key,
    required this.selectedPage,
  });

  @override
  State<StaffDrawerMenu> createState() => _StaffDrawerMenuState();
}

class _StaffDrawerMenuState extends State<StaffDrawerMenu> {
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

  changeProfileImage(Uint8List image) async {
    await FirebaseMethods().changeProfileImage(
      image: image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: blueDrawerColor,
      child: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return UserAccountsDrawerHeader(
                    currentAccountPicture: const CircleAvatar(
                      foregroundColor: backgroundWhiteColor,
                      backgroundColor: darkblueAppbarColor,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: blueDrawerColor,
                        ),
                      ),
                    ),
                    accountName: LoadingAnimationWidget.staggeredDotsWave(
                        color: backgroundWhiteColor, size: 18),
                    accountEmail: LoadingAnimationWidget.staggeredDotsWave(
                        color: backgroundWhiteColor, size: 18),
                  );
                }

                return UserAccountsDrawerHeader(
                  currentAccountPicture: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          (isOpenProfile) ? selectImage() : null;
                        },
                        child: CircleAvatar(
                          backgroundColor: backgroundWhiteColor,
                          backgroundImage:
                              NetworkImage(snapshot.data!['photoURL']),
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
                  accountName: Text(snapshot.data!['nameDetails']),
                  accountEmail: Text(snapshot.data!['email']),
                  onDetailsPressed: () {
                    setState(() {
                      isOpenProfile = !isOpenProfile;
                    });
                  },
                );
              }),
          Expanded(
              child: isOpenProfile
                  ? const ProfileScreen()
                  : Scaffold(
                      backgroundColor: Colors.transparent,
                      body: ListView(
                        padding: const EdgeInsets.only(top: 4),
                        children: [
                          // quest select
                          ListTile(
                            tileColor: (widget.selectedPage == IS_QUEST_PAGE)
                                ? focusBlueColor
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(color: focusBlueColor),
                                borderRadius: BorderRadius.circular(12)),
                            leading: projectIcon,
                            trailing: (widget.selectedPage == IS_QUEST_PAGE)
                                ? rightArrowPageIcon
                                : null,
                            title: const Text(
                              "Nhiệm vụ",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const StaffHomeScreen()));
                            },
                          ),
                          // notification select
                          ListTile(
                            tileColor: (widget.selectedPage == IS_NOTIFY_PAGE)
                                ? focusBlueColor
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(color: focusBlueColor),
                                borderRadius: BorderRadius.circular(12)),
                            leading: defaultnotifyIcon,
                            trailing: (widget.selectedPage == IS_NOTIFY_PAGE)
                                ? rightArrowPageIcon
                                : getNumberNotifications(
                                    isBottom: false, size: 28, fontSize: 13),
                            title: const Text(
                              "Thông báo",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () async {
                              Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const StaffNotifyScreen()));
                              String res =
                                  await FirebaseMethods().refreshNotifyNumber();
                              if (res != 'success') {
                                if (context.mounted) {
                                  showSnackBar(context: context, content: res, isError: true);
                                }
                              }
                            },
                          ),
                          //event select
                          ListTile(
                            tileColor: (widget.selectedPage == IS_EVENT_PAGE)
                                ? focusBlueColor
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(color: focusBlueColor),
                                borderRadius: BorderRadius.circular(12)),
                            leading: eventIcon,
                            trailing: (widget.selectedPage == IS_EVENT_PAGE)
                                ? rightArrowPageIcon
                                : null,
                            title: const Text(
                              "Bảng chấm công",
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const StaffTimeKeepingScreen()));
                            },
                          )
                        ],
                      ),
                      floatingActionButton: TextBoxButton(
                          color: errorRedColor,
                          text: "Đăng xuất",
                          fontSize: 14,
                          width: 80,
                          height: 36,
                          funtion: signOut),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.endFloat,
                    )),
        ],
      ),
    );
  }
}
