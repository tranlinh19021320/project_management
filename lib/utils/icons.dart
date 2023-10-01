import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/utils/colors.dart';

Image emailIcon = Image.asset(
  "assets/icons/gmail.png",
  width: 20,
  height: 20,
  fit: BoxFit.fill,
);
Image detailNameIcon = Image.asset(
  "assets/icons/business-card.png",
  width: 20,
  height: 20,
  fit: BoxFit.fill,
);
Image usernameIcon = Image.asset(
  "assets/icons/user.png",
  width: 20,
  height: 20,
  fit: BoxFit.fill,
);
Image groupIcon = Image.asset(
  "assets/icons/teamwork.png",
  width: 20,
  height: 20,
  fit: BoxFit.fill,
);
Image passwordIcon = Image.asset(
  "assets/icons/password.png",
  width: 20,
  height: 20,
  fit: BoxFit.fill,
);
Image hidePasswordIcon = Image.asset(
  "assets/icons/hide.png",
  width: 20,
  height: 20,
  fit: BoxFit.fill,
  color: defaultIconColor,
);
Image viewPasswordIcon = Image.asset(
  "assets/icons/view.png",
  width: 20,
  height: 20,
  fit: BoxFit.fill,
  color: defaultIconColor,
);
Image createIcon = Image.asset(
  "assets/icons/create.png",
  width: 20,
  height: 20,
  fit: BoxFit.fill,
);
Image projectIcon = Image.asset(
  "assets/icons/project-management.png",
  width: 30,
  height: 30,
  fit: BoxFit.fill,
);
Image missionIcon = Image.asset(
  "assets/icons/target.png",
  width: 30,
  height: 30,
  fit: BoxFit.fill,
);
Image defaultnotifyIcon = Image.asset(
  "assets/icons/notify.png",
  width: 30,
  height: 30,
  fit: BoxFit.fill,
);
Image eventIcon = Image.asset(
  "assets/icons/event.png",
  width: 30,
  height: 30,
  fit: BoxFit.fill,
);
Image rightArrowIcon = Image.asset(
  "assets/icons/right-arrow.png",
  width: 30,
  height: 30,
  fit: BoxFit.fill,
);
Image leftArrowIcon = Image.asset(
  "assets/icons/left-arrow.png",
  width: 30,
  height: 30,
  fit: BoxFit.fill,
);
Image rightArrowPageIcon = Image.asset(
  "assets/icons/right-arrow-page.png",
  width: 30,
  height: 30,
  fit: BoxFit.fill,
);
Image loudspeakerIcon = Image.asset(
  "assets/icons/loudspeaker.png",
  width: 36,
  height: 36,
);
Image addIcon = Image.asset(
  "assets/icons/creaete-staff.png",
  width: 36,
  height: 36,
);
Image addImageIcon = Image.asset(
  "assets/icons/add_image.png",
  width: 28,
  height: 28,
);

const Icon correctIcon = Icon(
  Icons.check,
  color: correctGreenColor,
);
const Icon errorIcon = Icon(
  Icons.error,
  color: errorRedColor,
);

Image resizedIcon(String imagePath, double size) {
  return Image.asset(
    imagePath,
    width: size,
    height: size,
    fit: BoxFit.fill,
  );
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

getNumberNotifications(
    {double locate = 35,
    double size = 20,
    double fontSize = 10,
    bool isBottom = true, bool? isNotify}) {
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
        case true: notificationsNumber = notifyNumber;
        case false: notificationsNumber = reportNumber;
        case null: notificationsNumber = notifyNumber + reportNumber;
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
