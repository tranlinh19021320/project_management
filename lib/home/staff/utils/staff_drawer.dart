import 'package:flutter/material.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';
import '../../../firebase/firebase_methods.dart';
import '../../../start_screen/login.dart';
import '../../widgets/utils/user_profile.dart';

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

   selectImage() {
    setState(() {
      isLoadingImage = true;
    });
    selectAImage(context: context);
    
    setState(() {
      isLoadingImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: blueDrawerColor,
      child: Column(
        children: [
          userInfor(
              selectImage: selectImage,
              setState: () => setState(() {
                    isOpenProfile = !isOpenProfile;
                  }),
              isLoadingImage: isLoadingImage,
              isOpenProfile: isOpenProfile),
          Expanded(
              child: isOpenProfile
                  ? const ProfileScreen()
                  : Scaffold(
                      backgroundColor: Colors.transparent,
                      body: ListView(
                        padding: const EdgeInsets.only(top: 4),
                        children: [
                          // quest select
                          menuListTile(context: context, selectPage: widget.selectedPage, pageValue: IS_QUEST_PAGE),
                          // notification select
                          menuListTile(context: context, selectPage: widget.selectedPage, pageValue: IS_STAFF_NOTIFY_PAGE, isNotify: true),
                          //time keeping select
                          menuListTile(context: context, selectPage: widget.selectedPage, pageValue: IS_TIME_KEEPING_PAGE),
                          //reports select
                          menuListTile(context: context, selectPage: widget.selectedPage, pageValue: IS_REPORT_PAGE, isNotify: false)
                        ],
                      ),
                      floatingActionButton: textBoxButton(
                          color: errorRedColor,
                          text: "Đăng xuất",
                          fontSize: 14,
                          width: 100,
                          height: 38,
                          function: signOut),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.endFloat,
                    )),
        ],
      ),
    );
  }
}
