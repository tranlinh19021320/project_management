import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/home/widgets/reset_password.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/notify_dialog.dart';
import '../../firebase/firebase_methods.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController detailNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  late String userId;
  late FocusNode detailNameFocus;

  String nameDetails = '';
  bool isUpdateDetailName = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    detailNameController.text = "";
    userId = FirebaseAuth.instance.currentUser!.uid;
    detailNameFocus = FocusNode();
    detailNameFocus.addListener(() {
      if (!detailNameFocus.hasFocus) {
        if (isUpdateDetailName) {
          updateProfile();
        }
        setState(() {
          isUpdateDetailName = false;
        });
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    detailNameController.dispose();
    usernameController.dispose();
    groupController.dispose();

    // emailFocus.dispose();
    detailNameFocus.dispose();
  }

  updateProfile() async {
    if (nameDetails != detailNameController.text) {
      showDialog(
          context: context,
          builder: (_) =>
              const NotifyDialog(content: 'loading', isError: false));

      // only change name details
      String res = await FirebaseMethods().updateNameDetail(
          userId: userId, nameDetails: detailNameController.text);
      if (res == 'success') {
        detailNameController.text == "";
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (_) => NotifyDialog(content: res, isError: false));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator(
                color: backgroundWhiteColor,
              ),
            ),
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: blueDrawerColor,
                    color: backgroundWhiteColor,
                  ),
                );
              }

              emailController.text = snapshot.data!['email'];

              nameDetails = snapshot.data!['nameDetails'];
              if (detailNameController.text == "") {
                detailNameController.text = nameDetails;
              }

              usernameController.text = snapshot.data!['username'];
              groupController.text = snapshot.data!['group'];

              return Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //email text
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: emailIcon,
                          ),
                          prefixText: "Email: ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: defaultColor)),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      //details name text
                      TextField(
                        controller: detailNameController,
                        focusNode: detailNameFocus,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: detailNameIcon,
                            ),
                            prefixText: "Họ và tên: ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: defaultColor)),
                            suffixIcon: IconButton(
                              icon: isUpdateDetailName
                                  ? const Icon(
                                      Icons.update,
                                      color: focusBlueColor,
                                    )
                                  : const Icon(
                                      Icons.update_disabled,
                                      color: defaultIconColor,
                                    ),
                              onPressed: () {
                                setState(() {
                                  isUpdateDetailName = !isUpdateDetailName;

                                  if (isUpdateDetailName) {
                                    FocusScope.of(context)
                                        .requestFocus(detailNameFocus);
                                  } else {
                                    detailNameFocus.unfocus();
                                  }
                                });
                              },
                            )),
                        readOnly: !isUpdateDetailName,
                        onTapOutside: (event) {
                          detailNameFocus.unfocus();
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      //account username text
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: usernameIcon,
                          ),
                          prefixText: "Tài khoản: ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: defaultColor)),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      //group text
                      TextField(
                        controller: groupController,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: groupIcon,
                          ),
                          prefixText: "Nhóm: ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: defaultColor)),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextBoxButton(
                              color: buttonGreenColor,
                              text: "Đổi mật khẩu",
                              fontSize: 13,
                              width: 100,
                              height: 36,
                              funtion: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => ResetPasswordScreen(
                                          userId: userId,
                                        ));
                              }),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),

                      //
                    ],
                  ),
                ),
              );
            });
  }
}
