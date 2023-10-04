
import 'package:flutter/material.dart';
import 'package:project_management/utils/functions.dart';

//paths
String backgroundImage = "assets/images/background_image.jpg";
String defaultProfileImagePath = "assets/images/default-profile.jpg";
String keyImagePath = "assets/icons/key.png";
String staffImagePath = "assets/icons/staff.png";
String gmailImagePath = "assets/icons/gmail.png";
String detailNameImagePath = "assets/icons/business-card.png";
String usernameImagePath = "assets/icons/user.png";
String groupImagePath = "assets/icons/teamwork.png";
String passwordImagePath = "assets/icons/password.png";
String hidePasswordImagePath = "assets/icons/hide.png";
String viewImagePath = "assets/icons/view.png";
String createImagePath = "assets/icons/create.png";
String projectImagePath = "assets/icons/project-management.png";
String missionImagePath = "assets/icons/target.png";
String defaultNotifyImagePath = "assets/icons/notify.png";
String eventImagePath = "assets/icons/event.png";
String rightArrowImagePath = "assets/icons/right-arrow.png";
String leftArrowImagePath = "assets/icons/left-arrow.png";
String rightArrowPageImagePath = "assets/icons/right-arrow-page.png";
String louadspeakerImagePath = "assets/icons/loudspeaker.png";
String addImagePath = "assets/icons/creaete-staff.png";
String addImageImagePath = "assets/icons/add_image.png";

//Colors
const Color blackColor = Colors.black;
const Color backgroundWhiteColor = Colors.white;
const Color buttonGreenColor = Color.fromARGB(233, 132, 232, 96);
const Color textLightBlueColor = Color.fromARGB(214, 150, 178, 235);
const Color errorRedColor = Color.fromARGB(227, 246, 6, 6);
const Color correctGreenColor = Color.fromARGB(255, 91, 238, 54);
const Color textErrorRedColor = Color.fromARGB(255, 234, 117, 117);
const Color defaultColor = Color.fromARGB(255, 155, 155, 155);
const Color defaultIconColor = Color.fromARGB(255, 207, 207, 207);
const Color focusBlueColor = Color.fromARGB(255, 117, 208, 253);
const Color yellowColor = Color.fromARGB(255, 255, 246, 163);
const Color darkblueAppbarColor = Color.fromARGB(255, 14, 92, 181);
const Color blueDrawerColor = Color.fromARGB(255, 33, 108, 169);
const Color notifyIconColor = Color.fromARGB(255, 223, 203, 24);
Color darkblueColor =  Colors.blueGrey.shade700;
const Color defaultblueColor = Color.fromARGB(255, 80, 72, 160);
const Color darkgreenColor = Color.fromARGB(255, 60, 133, 60);

// Icon
Image emailIcon = resizedIcon(gmailImagePath);
Image detailNameIcon = resizedIcon(detailNameImagePath);
Image usernameIcon = resizedIcon(usernameImagePath);
Image groupIcon = resizedIcon(groupImagePath);
Image passwordIcon = resizedIcon(passwordImagePath);
Image hidePasswordIcon = resizedIcon(hidePasswordImagePath);
Image viewPasswordIcon = resizedIcon(viewImagePath);
Image createIcon = resizedIcon(createImagePath);
Image projectIcon = resizedIcon(projectImagePath, size: 30);
Image missionIcon = resizedIcon(missionImagePath, size: 30);
Image defaultnotifyIcon = resizedIcon(defaultNotifyImagePath, size: 30);
Image eventIcon = resizedIcon(eventImagePath, size: 30);
Image rightArrowIcon = resizedIcon(rightArrowImagePath, size: 30);
Image leftArrowIcon = resizedIcon(leftArrowImagePath, size: 30);
Image rightArrowPageIcon = resizedIcon(rightArrowPageImagePath, size: 30);
Image loudspeakerIcon = resizedIcon(louadspeakerImagePath, size: 36, isfill: false);
Image addIcon = resizedIcon(addImagePath, size: 36, isfill: false);
Image addImageIcon = resizedIcon(addImageImagePath, size: 28, isfill: false);

const Icon correctIcon = Icon(
  Icons.check,
  color: correctGreenColor,
);
const Icon errorIcon = Icon(
  Icons.error,
  color: errorRedColor,
);
// state parameters
const int IS_PROJECTS_PAGE = 0;
const int IS_PERSONAL_PAGE = 1;
const int IS_MANAGER_NOTIFY_PAGE = 2;
const int IS_EVENT_PAGE = 3;
const int IS_QUEST_PAGE = 4;
const int IS_STAFF_NOTIFY_PAGE = 5;
const int IS_TIME_KEEPING_PAGE = 6;
const int IS_REPORT_PAGE = 7;

const int IS_DEFAULT_STATE = 2;
const int IS_CORRECT_STATE = 1;
const int IS_ERROR_STATE = 0;
const int IS_ERROR_FORMAT_STATE = 3;


const int IS_SUBMIT = 0;
const int IS_DOING = 1;
const int IS_CLOSING = 2;
const int IS_COMPLETE = 3;
const int IS_LATE = 4;

// notification type
const int STAFF_RECIEVE_MISSION = 0;
const int STAFF_COMPLETE_MISSION = 1;
const int MANAGER_APPROVE_PROGRESS = 2;
const int MISSION_IS_DELETED = 3;
const int STAFF_RECIEVE_MISSION_FROM_OTHER = 4;
const int MISSION_CHANGE_STAFF = 6;
const int MISSION_IS_OPEN = 5;
const int MISSION_IS_CHANGED = 7;
const int TIME_KEEPING = 8;

// report type
const int UPDATE_REPORT = 9;
const int BUG_REPORT = 10;
const int PRIVATE_REPORT = 11;


String manager = "Manager";

