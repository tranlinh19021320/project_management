import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';


Image resizedIcon(String imagePath,{double size = 20}) {
  return Image.asset(
    imagePath,
    width: size,
    height: size,
    fit: BoxFit.fill,
  );
}
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

showNotify(
    {required BuildContext context,
    String content = '',
    bool isLoading = false,
    bool isError = false}) {
  return isLoading
      ? showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
                backgroundColor: Colors.transparent,
                icon: LoadingAnimationWidget.inkDrop(
                    color: darkblueAppbarColor, size: 32),
                title: const Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 18,
                      color: blueDrawerColor,
                    ),
                  ),
                ),
              ))
      : showDialog(
          context: context,
          builder: (_) => AlertDialog(
                scrollable: true,
                backgroundColor: darkblueAppbarColor,
                iconPadding: const EdgeInsets.only(top: 6),
                icon: SizedBox(height: 24, width: 24, child: loudspeakerIcon),
                // backgroundColor: backgroundWhiteColor,

                actionsAlignment: MainAxisAlignment.center,
                actionsPadding: const EdgeInsets.only(bottom: 12),
                titlePadding: const EdgeInsets.only(top: 8, bottom: 8),
                title: Center(
                  child: Text(
                    content,
                    style: TextStyle(
                        color: isError ? notifyIconColor : correctGreenColor,
                        fontSize: 18),
                  ),
                ),
                actions: [
                  textBoxButton(
                      color: notifyIconColor,
                      text: 'OK',
                      fontSize: 16,
                      function: () {
                        Navigator.of(context).pop();
                      })
                ],
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

String staffRecieveMission({required String nameMission, required String description}) {
  String notify = "Bạn đã nhận được nhiệm vụ \"$nameMission\" với mô tả:\"$description\"";

  return "${notify.substring(0, 50)}...";
}
