import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/page_provider.dart';
import '../provider/user_provider.dart';

// images path
String backgroundImage = "assets/images/background_image.jpg";
// asset icon
Image emailIcon = Image.asset("assets/icons/gmail.png", width: 20, height: 20, fit: BoxFit.fill,);
Image detailNameIcon = Image.asset("assets/icons/business-card.png", width: 20, height: 20, fit: BoxFit.fill,);
Image usernameIcon = Image.asset("assets/icons/user.png", width: 20, height: 20, fit: BoxFit.fill,);
Image roleIcon = Image.asset("assets/icons/teamwork.png", width: 20, height: 20, fit: BoxFit.fill,);
Image passwordIcon = Image.asset("assets/icons/password.png", width: 20, height: 20, fit: BoxFit.fill,);
Image hidePasswordIcon = Image.asset("assets/icons/hide.png", width: 20, height: 20, fit: BoxFit.fill, color: defaultIconColor,);
Image viewPasswordIcon = Image.asset("assets/icons/view.png", width: 20, height: 20, fit: BoxFit.fill, color: defaultIconColor,);
Image createIcon = Image.asset("assets/icons/create.png", width: 20, height: 20, fit: BoxFit.fill,);
Image keyIcon = Image.asset("assets/icons/key.png", width: 20, height: 20, fit: BoxFit.fill,);
Image projectIcon = Image.asset("assets/icons/project-management.png", width: 36, height: 36, fit: BoxFit.fill,);
Image staffIcon = Image.asset("assets/icons/staff.png", width: 36, height: 36, fit: BoxFit.fill,);
Image notifyIcon = Image.asset("assets/icons/notify.png", width: 36, height: 36, fit: BoxFit.fill,);
Image eventIcon = Image.asset("assets/icons/event.png", width: 36, height: 36, fit: BoxFit.fill,);
Image rightArrorIcon = Image.asset("assets/icons/right-arrow.png", width: 28, height: 28, fit: BoxFit.fill,);




const Icon correctIcon = Icon(
  Icons.check,
  color: correctGreenColor,
);
const Icon errorIcon = Icon(
  Icons.error,
  color: errorRedColor,
);






// state parameters
int IS_DEFAULT_STATE = 2;
int IS_CORRECT_STATE = 1;
int IS_ERROR_STATE = 0;
int IS_ERROR_FORMAT_STATE = 3;

int IS_PROJECTS_PAGE = 0;
int IS_PERSONAL_PAGE = 1;
int IS_NOTIFY_PAGE = 2;
int IS_EVENT_PAGE = 3;

// colors
const Color backgroundWhiteColor = Colors.white;
const Color buttonGreenColor = Color.fromARGB(233, 129, 206, 101);
const Color textLightBlueColor = Color.fromARGB(214, 150, 178, 235);
const Color errorRedColor = Color.fromARGB(228, 255, 5, 5);
const Color correctGreenColor = Color.fromARGB(255, 91, 238, 54);
const Color textErrorRedColor = Color.fromARGB(255, 234, 117, 117);
const Color defaultColor = Color.fromARGB(255, 155, 155, 155);
const Color defaultIconColor = Color.fromARGB(255, 207, 207, 207);
Color focusBlueColor = Colors.blue;
Color darkblueAppbarColor = Colors.blue.shade800;
const Color blueDrawerColor = Color.fromARGB(255, 33, 108, 169);
const Color notifyIconColor = Color.fromARGB(255, 247, 229, 70);


//funtions

//funtion to show snack bar for events
showSnackBar(BuildContext context, String content, bool isError) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: isError
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(
                  Icons.warning,
                  color: errorRedColor,
                ),
              ),
              Text(
                " $content",
                style: const TextStyle(color: errorRedColor),
              ),
            ],
          )
        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Center(
              child: Icon(
                Icons.check_circle,
                color: correctGreenColor,
              ),
            ),
            Text(
              " $content",
              style: const TextStyle(color: correctGreenColor),
            ),
          ]),
  ));
}

// funtion to check email is valid or not
bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

// reset state provider
initStateProvider(BuildContext context, String userId) async {
    context.read<UserProvider>().getUserById(userId);
    context.read<PageProvider>().refreshPage();
  }
