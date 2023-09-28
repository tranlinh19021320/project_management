import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
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

// show snack bar
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

selectAnImage({required BuildContext context}) {
  showDialog(
      context: context,
      builder: (_) => SimpleDialog(
            backgroundColor: darkblueAppbarColor,
            title: const Text("Chọn ảnh"),
            surfaceTintColor: correctGreenColor,
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(18),
                child: const Text("Camera"),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List imageFile =
                      await pickImage(context, ImageSource.camera);
                  await FirebaseMethods().changeProfileImage(
                    image: imageFile,
                  );
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(18),
                child: const Text("Thư viện ảnh"),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List imageFile =
                      await pickImage(context, ImageSource.gallery);
                  await FirebaseMethods().changeProfileImage(
                    image: imageFile,
                  );
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(18),
                child: const Text(
                  "Hủy",
                  style: TextStyle(color: errorRedColor),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ));
}

// get image from url
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

        return circularPercentIndicator(percent: loadPercent, radius: size / 2);
      }

      return child;
    },
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    dense: true,
    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: getImageFromUrl(url: user.photoURL, size: size),
    ),
    title: Text(
      user.nameDetails,
      style: TextStyle(fontSize: fontsize),
    ),
    subtitle: Text(
      user.group,
      style: TextStyle(fontSize: fontsize - 2),
    ),
    trailing: (user.group == manager)
        ? resizedIcon(keyImage, 18)
        : resizedIcon(staffImage, 18),
  );
}

Widget userCard(
    {required String userId, double size = 40, double fontsize = 16}) {
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

        CurrentUser user = CurrentUser.fromSnap(user: snapshot.data!);

        return user1Card(user: user, size: size, fontsize: fontsize);
      });
}

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

// day into string
String dayToString({required DateTime time, int type = 0}) {
  return (type == 0)
      ? DateFormat("dd-MM-yyyy").format(time)
      : DateFormat("MM-yyyy").format(time);
}

// deffirence with date and now
String timeDateWithNow({required DateTime date}) {
  DateTime now = DateTime.now();

  if (now.year == date.year && now.month == date.month && now.day == date.day) {
    final deffirence = now.difference(date);
    if (deffirence.inHours != 0) {
      return "${deffirence.inHours} giờ trước";
    } else {
      if (deffirence.inMinutes != 0) {
        return "${deffirence.inMinutes} phút trước";
      } else {
        return "${deffirence.inSeconds} giây trước";
      }
    }
  }
  return "lúc ${DateFormat('HH:mm, dd').format(date)} tháng ${DateFormat('MM, yyyy').format(date)}";
}

bool isToDay(
    {String? dateString, DateTime? date, int? day, int? month, int? year}) {
  return (dateString != null)
      ? dayToString(time: DateTime.now()) == dateString
      : (date != null)
          ? dayToString(time: DateTime.now()) == dayToString(time: date)
          : (day != null && month != null && year != null)
              ? dayToString(time: DateTime.now()) ==
                  dayToString(time: DateTime(year, month, day))
              : false;
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
