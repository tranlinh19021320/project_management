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
Widget notifications(int notificationsNumber) {
  return SizedBox(
    width: 30,
    height: 30,
    child: Stack(children: [
      defaultnotifyIcon,
      (notificationsNumber != 0)
          ? Container(
              width: 30,
              height: 30,
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.only(bottom: 3),
              child: Container(
                width: 15,
                height: 15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: errorRedColor,
                    border: Border.all(color: blueDrawerColor, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    "$notificationsNumber",
                    style: const TextStyle(
                        fontSize: 10, color: backgroundWhiteColor),
                  ),
                ),
              ),
            )
          : Container(),
    ]),
  );
}
