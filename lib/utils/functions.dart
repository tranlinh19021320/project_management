
//funtions

//funtion to show snack bar for events
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/parameters.dart';

showSnackBar({required BuildContext context,required String content, bool isError = false}) {
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

// pick image
pickImage(BuildContext context, ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  if (context.mounted) {
    showDialog(
        context: context,
        builder: (_) =>
            const NotifyDialog(content: "Không chọn ảnh", isError: true));
  }
}

Color notifyColor({required int state}) {
  return (state == IS_CORRECT_STATE)
      ? correctGreenColor
      : (state == IS_DEFAULT_STATE)
          ? defaultColor
          : errorRedColor;
}

Icon? notifyIcon({required int state}) {
  return (state == IS_DEFAULT_STATE)
      ? null
      : (state == IS_CORRECT_STATE)
          ? correctIcon
          : errorIcon;
}