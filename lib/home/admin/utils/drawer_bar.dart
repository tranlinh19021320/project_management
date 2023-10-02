import 'package:flutter/material.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';
import '../../../firebase/firebase_methods.dart';
import '../../../start_screen/login.dart';
import 'package:project_management/utils/functions.dart';
import '../../widgets/user_profile.dart';

class DrawerMenu extends StatefulWidget {
  final int selectedPage;
  const DrawerMenu({
    super.key,
    required this.selectedPage,
  });

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
                          // project select
                          menuListTile(context: context, selectPage: widget.selectedPage, pageValue: IS_PROJECTS_PAGE),
                          // personal select
                          menuListTile(context: context, selectPage: widget.selectedPage, pageValue: IS_PERSONAL_PAGE),
                          // notification select
                          menuListTile(context: context, selectPage: widget.selectedPage, pageValue: IS_MANAGER_NOTIFY_PAGE, isNotify: true),
                          //event select
                          menuListTile(context: context, selectPage: widget.selectedPage, pageValue: IS_EVENT_PAGE, isNotify: false)
                        ],
                      ),
                      floatingActionButton: textBoxButton(
                          color: errorRedColor,
                          text: "Đăng xuất",
                          width: 100,
                          height: 38,
                          fontSize: 14,
                          function: signOut),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.endFloat,
                    )),
        ],
      ),
    );
  }
}
