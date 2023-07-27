import 'package:flutter/material.dart';

// images path
String backgroundImage = "assets/images/background_image.jpg";

// state parameters
int IS_DEFAULT_STATE = 2;
int IS_CORRECT_STATE = 1;
int IS_ERROR_STATE = 0;
int IS_ERROR_FORMAT_STATE = 3;

// colors
const Color buttonGreenColor = Color.fromARGB(233, 129, 206, 101);
const Color textLightBlueColor = Color.fromARGB(214, 150, 178, 235);
const Color notifErrorColor = Color.fromARGB(228, 255, 5, 5);
const Color notifCorrectColor = Color.fromARGB(255, 91, 238, 54);
const Color textErrorColor = Color.fromARGB(255, 234, 117, 117);
Color defaultTextFieldColor = Colors.grey.shade300;
Color focusTextFieldColor = Colors.blue;

// icon
const Widget correctIcon = Icon(
  Icons.check,
  color: notifCorrectColor,
);
const Widget errorIcon = Icon(Icons.error, color: notifErrorColor);

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
                  color: notifErrorColor,
                ),
              ),
              Text(
                " $content",
                style: const TextStyle(color: notifErrorColor),
              ),
            ],
          )
        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Center(
              child: Icon(
                Icons.check_circle,
                color: notifCorrectColor,
              ),
            ),
            Text(
              " $content",
              style: const TextStyle(color: notifCorrectColor),
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
