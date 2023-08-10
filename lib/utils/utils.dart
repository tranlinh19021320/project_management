import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/utils/notify_dialog.dart';
// images path
String backgroundImage = "assets/images/background_image.jpg";
String defaultProfileImage = "assets/images/default-profile.jpg";
String keyImage = "assets/icons/key.png";
String staffImage = "assets/icons/staff.png";

//path
String databaseURL =
    'https://project-management-89017-default-rtdb.asia-southeast1.firebasedatabase.app';
String projectId = "project-management-89017";
String clientEmail =
    "firebase-adminsdk-34nls@project-management-89017.iam.gserviceaccount.com";
String privateKey =
    "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCww4N5QSs6txve\nnDjUVqNkFs4I0PsDw7BXl4RWVYcxPgtWvssW5woVruOQVvq/9BHZXlP5DR4ME5nF\nJkHWnIUcFKblMWlFKylrmADZThd+bMB+2y3MstgDG3D3yVEt2EcIml/pSk6QWo2l\nW2yCCgUVv3ws1hGA/t17BCiXs2Q0XlykZ7H+wlLYCvLgID3DaRrOZ7vHIP/c7ReB\nBs/xuIU9FV2wj9duEvbQUSY1SRrQaLoi5Wnr4PVYCP1FUCY6+N4ZKGPXykW71XHH\n3/13gV+6/TI2qQgDM1Dk4f1U8vk/Sj1fWpG9lx1hNcF9JgHMX69HIUo7ljR7uIOs\nuxEr5hCPAgMBAAECggEABRil9j2AQxGbbpgfdVPIIy8bIprv2cRvFZ9rM9gEbVGG\nHyqiDVd87XIc4oD3eshNKXC0SBZuOtfn04zOUiMyHUSlKS97AwEDETSRNbKwL7dv\n91hXYjL30mMcpzA5NHKrXZ6hzEaVrEjIE6/mmXszeVSLfnlviMIQXacZioIkDfRs\nJd+IjxRFgEu/5FRv2/VrNJpPiAzmxmcdqOzydv9DiDKBcQIfDbE2OkRJXfozBnbB\nBITdyDHcmjz7u3JT8skK/YgW+wG0mcmikJKenTxzhgpcyCjCoIHOkcLdkCpzQa0H\nVO4rxskugQmC4+uXtLg5tD9X+N0oFsGesUh3e7tX4QKBgQDyGf/CPTnZVjWI4AVG\nEZhRoGsZtVRgw2bXcA8t8pI3Ozyn12tDay+1p8JZw16bbbygabiuajUcHL7jpBCD\nMhhIJE5io+Z5DoA1h3SagajIVC9Csp0Zl6tOt9wtnGiNSk8Xeudw5xMCoUil5WeJ\nJWp3821OnHiMHMlPn69t17No7wKBgQC66UoA4TEkrx6eWtYMKsQ7MBWuAtZVFVbS\nYpU3pebCDk5cW6y7mSxKx+MNcTrFv4KCR/4EUl4KINuu8clfRsudq0Wld0TK6q0M\nzbS6B4Sfds6jGViTz8yweAXV0D+2QPMnQLcL1/G9pDeieliRrLmuOCASFYNHPU5A\n3hQAhB2SYQKBgGADjZnz/ChEd1DEP3MtcTIWI8N7VW5WsEeKioqXZAOBe6m41jJT\npQUu9fXxdGjB2YfoxbRuLIfsoovXOjE9wcGCnI+kHrgt1wzjnovUFiL0uBWEjqdi\nri623hw8pn46VSmjtXviOHjXi983HpuWeiX+JYCCr5AprnDkjIdMfzuDAoGBALWB\nuoWkKW7wSBGLMHVcSncXuNXkl3LEaC2h4jnJ947XCa2SsOj0VBjCh3EUVfiWgww1\nES3tNrkrM2puDhlhzHVuTxHiAoHy5t2aHTjR+C5K11t3T5cqoiF0TGZX9qbr57Rk\nmdz8dRquEADOQpgkXaQbiLlG/tb9Z7KCdnYR1g3BAoGBAM4aRQJyd+tsRuh6OhIY\n16Iv/yXQVKE/apYC2UOIfH+yL7d7wggoGTIF/3LmXv10If4YeRy3Los0Ot+ZwfbO\nM+iTInC3E8Hz3sPsBcZ/KI+wzFLClqbrqYxN1wALS2Jvcl0ej6sem1sY7nLbftZj\nxIlL5IAxM5+5cGmucemOa2LX\n-----END PRIVATE KEY-----\n";
// asset icon
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
Widget notifyIcon(int notificationsNumber) {
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

// state parameters
const int IS_DEFAULT_STATE = 2;
const int IS_CORRECT_STATE = 1;
const int IS_ERROR_STATE = 0;
const int IS_ERROR_FORMAT_STATE = 3;

const int IS_PROJECTS_PAGE = 0;
const int IS_PERSONAL_PAGE = 1;
const int IS_NOTIFY_PAGE = 2;
const int IS_EVENT_PAGE = 3;

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

String manager = "Manager";
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

Widget groupDropdown({required String companyId, required String groupSelect, required String isWordAtHead, required Function onSelectValue,}) {
  // Function(String value) onSelectValue;
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingAnimationWidget.hexagonDots(
              color: darkblueAppbarColor, size: 20);
        }
        String selectValue = groupSelect;
        List<String> groups = [];
        if (isWordAtHead != "") groups.add(isWordAtHead);
        for (var value in snapshot.data!['group']) {
          groups.add(value.toString());
        }
        return DropdownButton(
          menuMaxHeight: 200,
          alignment: Alignment.center,
          value: selectValue,
          style: const TextStyle(
            fontSize: 13,
          ),
          underline: Container(
            height: 1,
            color: backgroundWhiteColor,
          ),
          items: groups.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                    color: (value == selectValue)
                        ? notifyIconColor
                        : backgroundWhiteColor),
              ),
            );
          }).toList(),
          onChanged: (val) {
              onSelectValue(val!);
          },
        );
      });
}
