import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/home/unit_card/reset_password.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/utils.dart';
import '../../firebase/firebase_methods.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController detailNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  late FocusNode detailNameFocus;

  String nameDetails = '';
  bool isUpdateDetailName = false;

  @override
  void initState() {
    super.initState();
    detailNameController.text = "";

    detailNameFocus = FocusNode();
    detailNameFocus.addListener(() {
      if (!detailNameFocus.hasFocus) {
        setState(() {
          isUpdateDetailName = false;
        });
      }
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
    showDialog(
        context: context,
        builder: (_) => const NotifyDialog(content: 'loading', isError: false));

    // only change name details
    String res = await FirebaseMethods().updateNameDetail(
        userId: widget.userId, nameDetails: detailNameController.text);
    if (res == 'success') {
      if (context.mounted) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (_) => const NotifyDialog(
                content: "Cập nhật thành công!", isError: false));
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
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
                                  color: correctGreenColor,
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
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => ResetPasswordScreen(
                                    userId: widget.userId,
                                  ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: buttonGreenColor,
                          ),
                          width: 100,
                          height: 36,
                          child: const Center(
                              child: Text(
                            "Đổi mật khẩu",
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: updateProfile,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: focusBlueColor,
                          ),
                          width: 100,
                          height: 36,
                          child: const Center(
                              child: Text(
                            "Cập nhật",
                          )),
                        ),
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
