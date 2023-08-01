import 'package:flutter/material.dart';
import 'package:project_management/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  late FocusNode oldPasswordFocus;
  late FocusNode newPasswordFocus;

  int isPasswordState = IS_DEFAULT_STATE;

  bool isLockedOldPassword = true;
  bool isLockedNewPassword = true;

  @override
  void initState() {
    super.initState();
    usernameController.text = context.read<UserProvider>().getUsername();

    oldPasswordFocus = FocusNode();
    oldPasswordFocus.addListener(() {
      if (!oldPasswordFocus.hasFocus) {
        if (oldPasswordController.text == "") {
          setState(() {
            isPasswordState = IS_DEFAULT_STATE;
          });
        } else {
          if (isCorrectPassword()) {
            setState(() {
              isPasswordState = IS_CORRECT_STATE;
            });
          } else {
            setState(() {
              isPasswordState = IS_ERROR_STATE;
            });
          }
        }
      }
    });
    newPasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();

    oldPasswordFocus.dispose();
    newPasswordFocus.dispose();
  }

  isCorrectPassword() {
    return (oldPasswordController.text == context.read<UserProvider>().getPassword());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: darkblueAppbarColor,
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding:const EdgeInsets.only(bottom: 24, right: 12),
      title: const Center(
        child: Text(
          "Đổi mật khẩu",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: correctGreenColor),
        ),
      ),
      content: Form(
          child: Column(
        children: [
          // username
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: usernameIcon,
              ),
              label:const  Text("Tài khoản "),
              
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: defaultColor)),
            ),
            readOnly: true,
          ),
          const SizedBox(
            height: 8,
          ),
          // old password
          TextFormField(
            controller: oldPasswordController,
            focusNode: oldPasswordFocus,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: passwordIcon,
              ),
              label: const Text("Mật khẩu cũ"),
              // notify if password is error
              helperText: isPasswordState == IS_ERROR_STATE
                  ? "Sai mật khẩu!"
                  : isPasswordState == IS_DEFAULT_STATE
                      ? "Nhập mật khẩu cũ để xác thực"
                      : "Đã xác thực mật khẩu",
              helperStyle: TextStyle(
                  color: (isPasswordState == IS_CORRECT_STATE)
                      ? correctGreenColor
                      : (isPasswordState == IS_DEFAULT_STATE)
                          ? backgroundWhiteColor
                          : errorRedColor,
                  fontSize: 11),

              //outline border
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: isPasswordState == IS_ERROR_STATE ? errorRedColor : 
                            isPasswordState == IS_CORRECT_STATE
                        ? correctGreenColor
                        : defaultColor),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),

              suffixIcon: IconButton(
                icon: isLockedOldPassword
                    ? hidePasswordIcon
                    : viewPasswordIcon,
                onPressed: () {
                  setState(() {
                    isLockedOldPassword = !isLockedOldPassword;
                  });
                },
              ),
            ),
            obscureText: isLockedOldPassword,
            onEditingComplete:() => FocusScope.of(context).requestFocus(newPasswordFocus),
          ),
          const SizedBox(
            height: 8,
          ),
          // new password
          TextFormField(
            controller: newPasswordController,
            focusNode: newPasswordFocus,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: createIcon,
              ),
              label: const Text("Mật khẩu mới"),
              
              //outline border
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: defaultColor),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),

              suffixIcon: IconButton(
                icon: isLockedNewPassword
                    ? hidePasswordIcon
                    : viewPasswordIcon,
                onPressed: () {
                  setState(() {
                    isLockedNewPassword = !isLockedNewPassword;
                  });
                },
              ),
            ),
            obscureText: isLockedNewPassword,
            onEditingComplete: () {},
          ),
        ],
      )),
      
      actions: [
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: buttonGreenColor,
            ),
            width: 80,
            height: 36,
            child: const Center(
                child: Text(
              "Cập nhật",
            )),
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: textErrorRedColor,
            ),
            width: 64,
            height: 36,
            child: const Center(
                child: Text(
              "Hủy",
            )),
          ),
        ),
      ],
    );
  }
}
