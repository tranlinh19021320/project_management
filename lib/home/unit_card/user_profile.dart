
import 'package:flutter/material.dart';
import 'package:project_management/home/unit_card/reset_password.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../firebase/firebase_methods.dart';
import '../../provider/user_provider.dart';

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

  late FocusNode emailFocus;
  late FocusNode detailNameFocus;

  bool isUpdateEmail = false;
  bool isUpdateDetailName = false;

  int isEmailState = IS_DEFAULT_STATE;

  @override
  void initState() {
    super.initState();
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    emailController.text = user.getCurrentUser.email;
    detailNameController.text = user.getCurrentUser.nameDetails;
    usernameController.text = user.getCurrentUser.username;
    groupController.text = user.getCurrentUser.group;

    emailFocus = FocusNode();
    emailFocus.addListener(() async {
      if (!emailFocus.hasFocus) {
        setState(() {
          isUpdateEmail = false;
        });
        if (!isChangedEmail()) {
          setState(() {
            isEmailState = IS_DEFAULT_STATE;
          });
        } else {
          isEmailState =
              await FirebaseMethods().checkAlreadyEmail(emailController.text);
          setState(() {});
          if (isEmailState == IS_ERROR_STATE) {
            if (context.mounted) {
              showDialog(
                  context: context,
                  builder: (_) => const NotifyDialog(
                      content: ("Email đã đăng ký!"), isError: true));
            }
          } else if (isEmailState == IS_ERROR_FORMAT_STATE) {
            if (context.mounted) {
              showDialog(
                  context: context,
                  builder: (_) => const NotifyDialog(
                      content: ("Lỗi định dạng Email!"), isError: true));
            }
          }
        }
      }
    });

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

    emailFocus.dispose();
    detailNameFocus.dispose();
  }

  isChangedEmail() {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    return (emailController.text != user.getCurrentUser.email);
  }

  isUpdate() {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    return (isChangedEmail() ||
        detailNameController.text != user.getCurrentUser.nameDetails);
  }

  updateProfile() async {
    if (isUpdate()) {
      String res = await context
          .read<UserProvider>()
          .updateUser(emailController.text, detailNameController.text);
      if (context.mounted) {
        if (res == 'success') {
          showDialog(
              context: context,
              builder: (_) => const NotifyDialog(
                  content: "Cập nhật thành công!", isError: false));
        } else {
          showSnackBar(context, res, true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //email text
            TextField(
              controller: emailController,
              focusNode: emailFocus,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: emailIcon,
                  ),
                  prefixText: "Email: ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isEmailState == IS_ERROR_STATE ||
                                  isEmailState == IS_ERROR_FORMAT_STATE
                              ? errorRedColor
                              : isEmailState == IS_CORRECT_STATE
                                  ? correctGreenColor
                                  : defaultColor)),
                  suffixIcon:
                      (context.watch<UserProvider>().getCurrentUser.email != "")
                          ? null
                          : IconButton(
                              icon: isUpdateEmail
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
                                  isUpdateEmail = !isUpdateEmail;
                                  if (isUpdateEmail) {
                                    FocusScope.of(context)
                                        .requestFocus(emailFocus);
                                  } else {
                                    emailFocus.unfocus();
                                  }
                                });
                              },
                            )),
              readOnly: !isUpdateEmail,
              onEditingComplete: () => emailFocus.unfocus(),
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
                          FocusScope.of(context).requestFocus(detailNameFocus);
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
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
                        builder: (_) => const ResetPasswordScreen());
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
  }
}
