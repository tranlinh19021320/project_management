import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    showNotify(context: context, content: "Không chọn ảnh", isError: true);
  }
}

pickImages(BuildContext context) async {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> list = await imagePicker.pickMultiImage();
  List<Uint8List> imageList = [];
  for (int i = 0; i < list.length; i++) {
    imageList.add(await list[i].readAsBytes());
  }
  if (imageList.isNotEmpty) {
    return imageList;
  }
  if (context.mounted) {
    showNotify(context: context, content: "Không chọn ảnh", isError: true);
  }
}

Future<Uint8List?> selectAImage(
    {required BuildContext context, bool isSave = true}) async {
  Uint8List? imageFile;
  return await showDialog(
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
                  imageFile = await pickImage(context, ImageSource.camera);
                  if (imageFile != null && isSave) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      showNotify(context: context, isLoading: true);
                    }
                    await FirebaseMethods().changeProfileImage(
                      image: imageFile!,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else if (context.mounted) {
                    Navigator.of(context).pop(imageFile);
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(18),
                child: const Text("Thư viện ảnh"),
                onPressed: () async {
                  imageFile = await pickImage(context, ImageSource.gallery);
                  if (imageFile != null && isSave) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      showNotify(context: context, isLoading: true);
                    }
                    await FirebaseMethods().changeProfileImage(
                      image: imageFile!,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else if (context.mounted) {
                    Navigator.of(context).pop(imageFile);
                  }
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
Widget getCircleImageFromUrl({
  required String url,
  double radius = 32,
}) {
  return ClipOval(
    child: Image.network(
      url,
      width: radius * 2,
      height: radius * 2,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        int? totalSize;
        int? downloadSize;
  
        totalSize = loadingProgress?.expectedTotalBytes;
        downloadSize = loadingProgress?.cumulativeBytesLoaded;
  
        if (totalSize != null && downloadSize != null) {
          var loadPercent = (downloadSize / totalSize).toDouble();
  
          return circularPercentIndicator(percent: loadPercent, radius: radius, lineWidth: radius/2, );
        }
  
        return child;
      },
    ),
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
    leading: getCircleImageFromUrl(url: user.photoURL, radius: size/2),
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

Future<List<Uint8List>> getImageList({required List photoURL}) async {
  List<Uint8List> imageList = [];
  for (int i = 0; i < photoURL.length; i++) {
    String url = photoURL[i];
    Uint8List image = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
    imageList.add(image);
  }
  return imageList;
}
