import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/screens/event_screen.dart';
import 'package:project_management/home/admin/screens/notify_screen.dart';
import 'package:project_management/home/admin/screens/personal_screen.dart';
import 'package:project_management/home/admin/screens/projects_screen.dart';
import 'package:project_management/home/admin/utils/drawer_bar.dart';
import 'package:project_management/home/staff/screens/staff_home.dart';
import 'package:project_management/home/staff/screens/staff_notify_screen.dart';
import 'package:project_management/home/staff/screens/staff_reports.dart';
import 'package:project_management/home/staff/screens/staff_time_keeping.dart';
import 'package:project_management/home/staff/utils/staff_drawer.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';

// color
Color notifyColor({required int state}) {
  return (state == IS_CORRECT_STATE)
      ? correctGreenColor
      : (state == IS_DEFAULT_STATE)
          ? defaultColor
          : errorRedColor;
}

// icon
Icon? notifyIcon({required int state}) {
  return (state == IS_DEFAULT_STATE)
      ? null
      : (state == IS_CORRECT_STATE)
          ? correctIcon
          : errorIcon;
}

// Icon with having notifications
Widget menuIcon() {
  return SizedBox(
    width: 35,
    height: 35,
    child: Stack(children: [
      const Icon(
        Icons.menu,
        size: 35,
      ),
      getNumberNotifications()
    ]),
  );
}

Widget leadingIcon({required int page}) {
  switch (page) {
    case IS_PROJECTS_PAGE:
      return projectIcon;
    case IS_PERSONAL_PAGE:
      return resizedIcon(staffImagePath, size: 30);
    case IS_MANAGER_NOTIFY_PAGE:
      return defaultnotifyIcon;
    case IS_EVENT_PAGE:
      return eventIcon;
    case IS_QUEST_PAGE:
      return projectIcon;
    case IS_STAFF_NOTIFY_PAGE:
      return defaultnotifyIcon;
    case IS_TIME_KEEPING_PAGE:
      return eventIcon;
    case IS_REPORT_PAGE:
      return loudspeakerIcon;
    default:
      return Container();
  }
}

String namePage(int page) {
  switch (page) {
    case IS_PROJECTS_PAGE:
      return "Dự án";
    case IS_PERSONAL_PAGE:
      return "Nhân sự";
    case IS_MANAGER_NOTIFY_PAGE:
      return "Thông báo";
    case IS_EVENT_PAGE:
      return "Sự kiện";
    case IS_QUEST_PAGE:
      return 'Nhiệm vụ';
    case IS_STAFF_NOTIFY_PAGE:
      return 'Thông báo';
    case IS_TIME_KEEPING_PAGE:
      return 'Bảng chấm công';
    case IS_REPORT_PAGE:
      return 'Báo cáo';
    default:
      return "";
  }
}

Widget drawer(page) {
  switch (page) {
    case IS_PROJECTS_PAGE ||
          IS_PERSONAL_PAGE ||
          IS_MANAGER_NOTIFY_PAGE ||
          IS_EVENT_PAGE:
      return DrawerMenu(
        selectedPage: page,
      );
    case IS_QUEST_PAGE ||
          IS_STAFF_NOTIFY_PAGE ||
          IS_TIME_KEEPING_PAGE ||
          IS_REPORT_PAGE:
      return StaffDrawerMenu(
        selectedPage: page,
      );
    default:
      return Container();
  }
}

Widget card(
    {Color color = darkblueAppbarColor,
    double? width,
    double? height,
    required VoidCallback? onTap,
    required Widget? title,
    required Widget? subtitle,
    Widget? leading,
    Widget? trailing}) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 2, left: 5, right: 5),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: focusBlueColor),
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
      ),
    ),
  );
}

Widget mainScreen(page, {required Widget body, Widget? floatingActionButton}) {
  return Container(
    decoration: BoxDecoration(
      image:
          DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.fill),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: darkblueAppbarColor,
        title: Text(namePage(page)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: menuIcon()),
        ),
      ),
      drawer: drawer(page),
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: floatingActionButton,
    ),
  );
}

Widget screen({required int page}) {
  switch (page) {
    case IS_PROJECTS_PAGE:
      return const ProjectsScreen();
    case IS_PERSONAL_PAGE:
      return const PersonalScreen();
    case IS_MANAGER_NOTIFY_PAGE:
      return const NotifyScreen();
    case IS_EVENT_PAGE:
      return const EventScreen();
    case IS_QUEST_PAGE:
      return const StaffHomeScreen();
    case IS_STAFF_NOTIFY_PAGE:
      return const StaffNotifyScreen();
    case IS_TIME_KEEPING_PAGE:
      return const StaffTimeKeepingScreen();
    case IS_REPORT_PAGE:
      return const StaffReportsScreen();
    default:
      return Container();
  }
}

ListTile menuListTile({
  required BuildContext context,
  required int selectPage,
  bool? isNotify,
  required int pageValue,
}) {
  return ListTile(
    tileColor: (selectPage == pageValue) ? focusBlueColor : Colors.transparent,
    shape: RoundedRectangleBorder(
        side: const BorderSide(color: focusBlueColor),
        borderRadius: BorderRadius.circular(12)),
    leading: leadingIcon(page: pageValue),
    trailing: (selectPage == pageValue)
        ? rightArrowPageIcon
        : (isNotify != null)
            ? getNumberNotifications(
                isBottom: false,
                size: 28,
                fontSize: 13,
                isNotify: isNotify,
              )
            : null,
    title: Text(
      namePage(pageValue),
      style: const TextStyle(fontSize: 16),
    ),
    onTap: () async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => screen(page: pageValue)));
      if (isNotify != null) {
        String res = "";
        if (isNotify) {
          res = await FirebaseMethods().refreshNotifyNumber();
        } else {
          res = await FirebaseMethods().refreshReportNumber();
        }

        if (res != 'success') {
          if (context.mounted) {
            showSnackBar(context: context, content: res, isError: true);
          }
        }
      }
    },
  );
}

Widget textBoxButton(
    {required Color color,
    required String text,
    double fontSize = 12,
    double padding = 8,
    double radius = 12,
    Color textColor = backgroundWhiteColor,
    double? width,
    double? height,
    VoidCallback? function}) {
  return InkWell(
    onTap: function,
    child: Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Colors.transparent, offset: Offset(0.3, 0.3)),
          BoxShadow(color: backgroundWhiteColor, offset: Offset(0.3, 0.5)),
          BoxShadow(color: correctGreenColor, offset: Offset(0.5, 0.3)),
        ],
        color: color,
      ),
      width: (width != null) ? width : null,
      height: (height != null) ? height : null,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: textColor),
        ),
      ),
    ),
  );
}

getNumberNotifications(
    {double locate = 35,
    double size = 20,
    double fontSize = 10,
    bool isBottom = true,
    bool? isNotify}) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Icon(Icons.menu);
      }
      int notificationsNumber = 0;
      int notifyNumber = snapshot.data!['notifyNumber'];
      int reportNumber = snapshot.data!['reportNumber'];

      switch (isNotify) {
        case true:
          notificationsNumber = notifyNumber;
        case false:
          notificationsNumber = reportNumber;
        case null:
          notificationsNumber = notifyNumber + reportNumber;
      }
      return (notificationsNumber == 0)
          ? SizedBox(
              width: locate,
              height: locate,
            )
          : Container(
              width: locate,
              height: locate,
              alignment: (isBottom) ? Alignment.bottomRight : Alignment.center,
              margin: const EdgeInsets.only(bottom: 3),
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: errorRedColor,
                    border: Border.all(color: darkblueAppbarColor, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    (notificationsNumber < 99) ? "$notificationsNumber" : "99+",
                    style: TextStyle(
                        fontSize: fontSize, color: backgroundWhiteColor),
                  ),
                ),
              ),
            );
    },
  );
}

Widget getCircleImageFromUrl(
  String url, {
  double radius = 32,
  double? width,
  double? height,
}) {
  Widget image = Image.network(
    url,
    width: (width != null) ? (width - 2) : (radius * 2 - 4),
    height: (height != null) ? (height - 2) : (radius * 2 - 4),
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      int? totalSize;
      int? downloadSize;

      totalSize = loadingProgress?.expectedTotalBytes;
      downloadSize = loadingProgress?.cumulativeBytesLoaded;

      if (totalSize != null && downloadSize != null) {
        var loadPercent = (downloadSize / totalSize).toDouble();

        return circularPercentIndicator(
          percent: loadPercent,
          radius: 15,
          lineWidth: 5,
        );
      }

      return child;
    },
  );
  return (width != null || height != null)
      ? ClipRRect(borderRadius: BorderRadius.circular(12), child: image)
      : CircleAvatar(
          backgroundColor: focusBlueColor,
          radius: radius,
          child: ClipOval(child: image),
        );
}

// circle percent
CircularPercentIndicator circularPercentIndicator(
    {required double percent,
    required double radius,
    double lineWidth = 5,
    double? fontSize,
    bool textCenter = true}) {
  return CircularPercentIndicator(
    radius: radius,
    lineWidth: lineWidth,
    percent: percent,
    center: (!textCenter)
        ? null
        : Text("${(percent * 100).toStringAsFixed(0)}%",
            style: (fontSize == null) ? null : TextStyle(fontSize: fontSize)),
    progressColor: (percent <= 0.2)
        ? Colors.red
        : (percent <= 0.4)
            ? Colors.orange
            : (percent <= 0.7)
                ? Colors.yellow
                : Colors.green,
  );
}

// user card
Widget user1Card(
    {required CurrentUser user, double size = 40, double fontsize = 16}) {
  return ListTile(
    contentPadding: const EdgeInsets.only(left: 8, right: 8),
    dense: true,
    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    leading: getCircleImageFromUrl(user.photoURL, radius: size / 2),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.nameDetails,
          style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.bold),
        ),
        Text(
          user.group,
          style: TextStyle(fontSize: fontsize - 2),
        )
      ],
    ),
    trailing: (user.group == manager)
        ? resizedIcon(keyImagePath, size: 18)
        : resizedIcon(staffImagePath, size: 18),
  );
}

Widget user2Card(
    {required CurrentUser user, double size = 30, double fontsize = 14}) {
  return Row(
    children: [
      getCircleImageFromUrl(user.photoURL, radius: size / 2),
      const SizedBox(width: 8,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.nameDetails,
            style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.bold),
          ),
          Text(
            user.group,
            style: TextStyle(fontSize: fontsize - 2),
          )
        ],
      )
    ],
  );
}

Widget userCard(
    {required String userId,
    double size = 40,
    double fontsize = 16,
    int type = 1}) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Text("Not User");
        }

        CurrentUser user = CurrentUser.fromSnap(doc: snapshot.data!);

        return (type == 1)
            ? user1Card(user: user, size: size, fontsize: fontsize)
            : user2Card(user: user, size: size, fontsize: fontsize);
      });
}

// evalute for time keeping
Icon evaluateIcon({required int state, double size = 20}) {
  return (state == IS_COMPLETE)
      ? Icon(
          Icons.check,
          size: size,
          color: correctGreenColor,
        )
      : (state == IS_LATE)
          ? Icon(
              Icons.assignment_late_rounded,
              size: size,
              color: errorRedColor,
            )
          : Icon(
              Icons.circle,
              size: size,
              color: defaultColor,
            );
}

Widget evaluate(
    {required int state,
    double size = 20,
    Color color = backgroundWhiteColor}) {
  return Container(
    child: state == IS_CLOSING
        ? Row(
            children: [
              evaluateIcon(state: state, size: size),
              Text(
                " Chưa được đánh giá.",
                style: TextStyle(color: color),
              ),
            ],
          )
        : state == IS_COMPLETE
            ? Row(
                children: [
                  evaluateIcon(state: state, size: size),
                  Text(
                    " Hoàn thành tốt.",
                    style: TextStyle(color: color),
                  ),
                ],
              )
            : Row(
                children: [
                  evaluateIcon(state: state, size: size),
                  Text(
                    " Chậm tiến độ.",
                    style: TextStyle(color: color),
                  ),
                ],
              ),
  );
}

Widget newTextAnimation() {
  return AnimatedTextKit(
      repeatForever: true,
      pause: const Duration(milliseconds: 0),
      animatedTexts: [
        ColorizeAnimatedText('Mới',
            textStyle: const TextStyle(fontSize: 14),
            colors: [
              Colors.white,
              Colors.yellow,
              Colors.red,
              Colors.green,
              Colors.black,
              Colors.blue,
              Colors.purple,
            ]),
      ]);
}

Widget typeReport({
  required int type,
  double size = 24,
  double fontSize = 14,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 2, right: 5, top: 1, bottom: 1),
    decoration: BoxDecoration(
      color: (type == UPDATE_REPORT)
          ? focusBlueColor
          : (type == BUG_REPORT)
              ? textErrorRedColor
              : yellowColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
        children: (type == UPDATE_REPORT)
            ? [
                Icon(
                  Icons.update,
                  color: darkblueColor,
                  size: size,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "Cập nhật",
                  style: TextStyle(fontSize: fontSize, color: blackColor),
                )
              ]
            : (type == BUG_REPORT)
                ? [
                    Icon(
                      Icons.error,
                      color: errorRedColor,
                      size: size,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Bug",
                      style: TextStyle(fontSize: fontSize, color: blackColor),
                    )
                  ]
                : [
                    Icon(
                      Icons.more,
                      color: notifyIconColor,
                      size: size,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Ý kiến đóng góp",
                      style: TextStyle(fontSize: fontSize, color: blackColor),
                    )
                  ]),
  );
}

Widget userInfor({
  required VoidCallback selectImage,
  required VoidCallback setState,
  required bool isLoadingImage,
  required bool isOpenProfile,
}) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            isLoadingImage) {
          return UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: defaultColor,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: focusBlueColor,
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
                  (isOpenProfile) ? selectImage : null;
                },
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: darkblueAppbarColor,
                  child: getCircleImageFromUrl(snapshot.data!['photoURL']),
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
          onDetailsPressed: setState,
        );
      });
}
