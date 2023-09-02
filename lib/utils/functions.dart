//funtions

//funtion to show snack bar for events
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';

showSnackBar(
    {required BuildContext context,
    required String content,
    bool isError = false}) {
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

Image getImageFromUrl({
  required String url,
  double size = 64,
}) {
  return Image.network(
    url,
    width: size,
    height: size,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      int? totalSize;
      int? downloadSize;

      totalSize = loadingProgress?.expectedTotalBytes;
      downloadSize = loadingProgress?.cumulativeBytesLoaded;

      if (totalSize != null && downloadSize != null) {
        var loadPercent = (downloadSize / totalSize).toDouble();
        var loadPercentString = (loadPercent * 100).toStringAsFixed(2);

        return CircularPercentIndicator(
          radius: size / 2,
          percent: loadPercent,
          center: Text(
            "$loadPercentString%",
          ),
          progressColor: (loadPercent <= 0.2)
              ? Colors.red
              : (loadPercent <= 0.4)
                  ? Colors.orange
                  : (loadPercent <= 0.7)
                      ? Colors.yellow
                      : Colors.green,
        );
      }

      return child;
    },
  );
}

ListTile userCard({required CurrentUser user}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    dense: true,
    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: getImageFromUrl(url: user.photoURL, size: 40),
    ),
    title: Text(
      user.nameDetails,
      style: const TextStyle(fontSize: 16),
    ),
    subtitle: Text(user.group),
    trailing: (user.group == manager)
        ? resizedIcon(keyImage, 18)
        : resizedIcon(staffImage, 18),
  );
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

String dayToString({required DateTime time}) {
  return DateFormat("dd-MM-yyyy").format(time);
}

Future<bool> currentUserIsManager() async {
  CurrentUser user = await FirebaseMethods()
      .getCurrentUserByUserId(userId: FirebaseAuth.instance.currentUser!.uid);

  return (user.group == manager);
}
