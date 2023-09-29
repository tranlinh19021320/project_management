import 'package:flutter/material.dart';
import 'package:project_management/home/widgets/group_dropdown_button.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/parameters.dart';
import '../../../firebase/firebase_methods.dart';

class CreateStaff extends StatefulWidget {
  final String companyId;
  final String companyName;
  const CreateStaff({
    super.key,
    required this.companyId,
    required this.companyName,
  });
  @override
  State<CreateStaff> createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  late FocusNode emailFocus;
  late FocusNode usernameFocus;
  late FocusNode passwordFocus;
  late GroupDropdownButton groupDropdownButton;

  int isEmailState = IS_DEFAULT_STATE;
  int isAccountState = IS_DEFAULT_STATE;
  int isPasswordState = IS_DEFAULT_STATE;

  bool isLockedPassword = false;
  bool isCreateGroup = false;
  String groupSelect = 'Manager';
  bool isLoadingGroup = false;

  @override
  void initState() {
    super.initState();
    // dropdown button
    groupDropdownButton = GroupDropdownButton(
        companyId: widget.companyId,
        groupSelect: groupSelect,
        isWordAtHead: "",
        onSelectValue: onSelectValue);
    // text button

    emailFocus = FocusNode();
    emailFocus.addListener(() async {
      if (!emailFocus.hasFocus) {
        isEmailState = await FirebaseMethods()
            .checkAlreadyEmail(email: emailController.text);
      } else {
        isEmailState = IS_DEFAULT_STATE;
      }
      if (mounted) {
        setState(() {});
      }
    });
    usernameFocus = FocusNode();
    usernameFocus.addListener(() async {
      if (!usernameFocus.hasFocus) {
        isAccountState = await FirebaseMethods()
            .checkAlreadyAccount(username: usernameController.text);
      } else {
        isAccountState = IS_DEFAULT_STATE;
      }
      if (mounted) {
        setState(() {});
      }
    });
    passwordFocus = FocusNode();
    passwordFocus.addListener(() {
      if (passwordFocus.hasFocus) {
        isPasswordState = IS_DEFAULT_STATE;
      }
    });
  }

  onSelectValue(String value) {
    // print(value);
    setState(() {
      groupSelect = value;
    });
    print(groupSelect);
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();

    usernameFocus.dispose();
    passwordFocus.dispose();
  }

  updateGroup() async {
    setState(() {
      isLoadingGroup = true;
    });

    String res = await FirebaseMethods()
        .addGroup(companyId: widget.companyId, groupName: groupController.text);
    if (res != 'success') {
      if (context.mounted) {
        showSnackBar(context:context,content: res,isError: true);
      }
    } else {
      groupSelect = groupController.text;
      groupDropdownButton = GroupDropdownButton(
          companyId: widget.companyId,
          groupSelect: groupSelect,
          isWordAtHead: "",
          onSelectValue: onSelectValue);
      groupController.clear();
    }
    setState(() {
      isLoadingGroup = false;
      isCreateGroup = false;
    });
  }

  createStaff() async {
    showNotify(context: context, isLoading: true);
    if (isAccountState == IS_CORRECT_STATE &&
        isEmailState == IS_CORRECT_STATE) {
      if (passwordController.text == "") {
        setState(() {
          isPasswordState = IS_ERROR_STATE;
        });
      } else {
        String res = await FirebaseMethods().createUser(
            email: emailController.text,
            username: usernameController.text,
            password: passwordController.text,
            nameDetails: usernameController.text,
            photoURL: '',
            group: groupSelect,
            companyId: widget.companyId,
            companyName: widget.companyName);

        if (res == 'success') {
          if (context.mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            showNotify(context: context, content: "Tạo thành công! ", isError: true);
          }
        } else {
          if (context.mounted) {
            showSnackBar(context:context,content: res,isError: true);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: darkblueAppbarColor,
      title: const Center(
          child: Text(
        "Tạo tài khoản nhân viên",
        style: TextStyle(fontSize: 16),
      )),
      content: Form(
        child: Column(children: [
          //email account
          TextFormField(
            controller: emailController,
            focusNode: emailFocus,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: emailIcon,
              ),
              //notify if email is error
              helperText: isEmailState == IS_ERROR_STATE
                  ? "Email đã đăng ký!"
                  : isEmailState == IS_ERROR_FORMAT_STATE
                      ? "Lỗi định dạng Email!"
                      : null,
              helperStyle: const TextStyle(color: errorRedColor, fontSize: 14),

              // outline boder
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: notifyColor(state: isEmailState)),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),

              suffixIcon: notifyIcon(state: isEmailState),
            ),
            autofocus: true,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(usernameFocus),
          ),
          const SizedBox(
            height: 12,
          ),
          // username account
          TextFormField(
              controller: usernameController,
              focusNode: usernameFocus,
              onTapOutside: (event) => usernameFocus.unfocus(),
              decoration: InputDecoration(
                labelText: "Tài khoản",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: usernameIcon,
                ),
                // notify if username is error
                helperText: isAccountState == IS_ERROR_STATE
                    ? "Tài khoản đã đăng ký!"
                    : null,
                helperStyle:
                    const TextStyle(color: errorRedColor, fontSize: 14),
                // outline boder
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: notifyColor(state: isAccountState)),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                suffixIcon: notifyIcon(state: isAccountState),
              ),
              onFieldSubmitted: (value) {
                usernameFocus.unfocus();
                if (mounted) {
                  setState(() {});
                }
                FocusScope.of(context).requestFocus(passwordFocus);
              }),
          const SizedBox(
            height: 12,
          ),

          //password
          TextFormField(
            controller: passwordController,
            focusNode: passwordFocus,
            decoration: InputDecoration(
              labelText: "Mật khẩu",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: passwordIcon,
              ),
              //notify if password is empty
              helperText: isPasswordState == IS_ERROR_STATE
                  ? "Vui lòng nhập mật khẩu!"
                  : null,
              helperStyle: const TextStyle(color: errorRedColor, fontSize: 14),
              //outline border
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: notifyColor(state: isPasswordState)),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              //icon lock
              suffixIcon: IconButton(
                icon: isLockedPassword ? hidePasswordIcon : viewPasswordIcon,
                onPressed: () {
                  setState(() {
                    isLockedPassword = !isLockedPassword;
                  });
                },
              ),
            ),
            obscureText: isLockedPassword,
            onFieldSubmitted: (value) {
              passwordFocus.unfocus;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          (isLoadingGroup)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : (isCreateGroup)
                  ? Row(
                      children: [
                        const Text(
                          "Nhóm:  ",
                          style: TextStyle(fontSize: 16),
                        ),
                        // group
                        Expanded(
                          child: SizedBox(
                            width: 100,
                            height: 32,
                            child: TextFormField(
                              controller: groupController,
                              autofocus: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        // createGroupButton,
                        TextBoxButton(
                            color: focusBlueColor,
                            text: "Tạo",
                            fontSize: 14,
                            width: 48,
                            height: 32,
                            funtion: updateGroup),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isCreateGroup = false;
                                groupController.clear();
                              });
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: defaultColor,
                              size: 28,
                            ))
                      ],
                    )
                  : Row(
                      children: [
                        const Text(
                          "Nhóm:  ",
                          style: TextStyle(fontSize: 16),
                        ),
                        groupDropdownButton,
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isCreateGroup = true;
                              });
                            },
                            icon: createIcon,
                          ),
                        )
                      ],
                    )
        ]),
      ),
      actions: [
        TextBoxButton(
        color: buttonGreenColor,
        text: "Tạo",
        fontSize: 14,
        width: 80,
        height: 36,
        funtion: createStaff),
        //  cancelButton,
        TextBoxButton(
            color: textErrorRedColor,
            text: "Hủy",
            fontSize: 14,
            width: 64,
            height: 36,
            funtion: () => Navigator.of(context).pop()),
      ],
    );
  }
}
