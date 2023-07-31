import 'package:flutter/material.dart';

// images path
String backgroundImage = "assets/images/background_image.jpg";

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
Color focusBlueColor = Colors.blue;
Color darkblueAppbarColor = Colors.blue.shade800;
const Color blueDrawerColor = Color.fromARGB(255, 33, 108, 169);

// icon
const Widget correctIcon = Icon(
  Icons.check,
  color: correctGreenColor,
);
const Widget errorIcon = Icon(Icons.error, color: correctGreenColor);

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
