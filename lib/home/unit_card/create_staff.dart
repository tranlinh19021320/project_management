import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../firebase/firebase_methods.dart';
import '../../provider/user_provider.dart';

class CreateStaff extends StatefulWidget {
  const CreateStaff({super.key});

  @override
  State<CreateStaff> createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController groupController = TextEditingController();

  late FocusNode usernameFocus;
  late FocusNode passwordFocus;

  int isAccountState = IS_DEFAULT_STATE;
  int isPasswordState = IS_DEFAULT_STATE;

  bool isLockedPassword = false;
  bool isCreateGroup = false;
  List<String> groups = ['Tất cả'];
  String groupSelect = 'Tất cả';
  bool isLoadingGroup = false;

  @override
  void initState() {
    super.initState();
    getListGroup();
    usernameFocus = FocusNode();
    usernameFocus.addListener(() async {
      if (!usernameFocus.hasFocus) {
        isAccountState = await FirebaseMethods()
            .checkAlreadyAccount(usernameController.text);
        setState(() {});
      } else {
        setState(() {
          isAccountState = IS_DEFAULT_STATE;
        });
      }
    });
    passwordFocus = FocusNode();
    passwordFocus.addListener(() {
      if (passwordFocus.hasFocus) {
        setState(() {
          isPasswordState = IS_DEFAULT_STATE;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();

    usernameFocus.dispose();
    passwordFocus.dispose();
  }

  getListGroup() async {
    try {
      groups.clear();
      groups.add('Tất cả');
      UserProvider user = Provider.of<UserProvider>(context, listen: false);
      var snap = await FirebaseFirestore.instance
          .collection('companies')
          .doc(user.getCurrentUser.companyId)
          .get();
      for (var value in snap.data()!['group']) {
        groups.add(value.toString());
      }
      setState(() {});
      //showDialog(context: context, builder: (_) => NotifyDialog(content: groups.toString(), isError: false));
    } catch (e) {
      showSnackBar(context, e.toString(), true);
    }
  }

  updateGroup() async {
    setState(() {
      isLoadingGroup = true;
    });
    if (!groups.contains(groupController.text)) {
      UserProvider user = Provider.of<UserProvider>(context, listen: false);
      String res = await FirebaseMethods()
          .updateGroup(user.getCurrentUser.companyId, groupController.text);
      if (res == 'success') {
        groups.add(groupController.text);
      } else {
        if (context.mounted) {
          showSnackBar(context, res, true);
        }
      }
    }
    setState(() {
      isLoadingGroup = false;
      groupSelect = groupController.text;
      groupController.clear();
      isCreateGroup = false;
    });
  }

  createStaff() async {
    showDialog(context: context, builder: (_) => const NotifyDialog(content: 'loading', isError: false));
    if (isAccountState == IS_CORRECT_STATE) {
      if (passwordController.text == "") {
        setState(() {
          isPasswordState = IS_ERROR_STATE;
        });
      } else {
        UserProvider user = Provider.of<UserProvider>(context, listen: false);
        String res = await FirebaseMethods().createUser(
            email: '',
            username: usernameController.text,
            password: passwordController.text,
            nameDetails: usernameController.text,
            photoURL: '',
            group: groupSelect,
            companyId: user.getCurrentUser.companyId,
            companyName: user.getCurrentUser.companyName);
        
        if (res == 'success') {
          if (context.mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop(groups);
          showDialog(context: context, builder: (_) =>const  NotifyDialog(content: "Tạo thành công!", isError: false));
          }

        } else {
          if (context.mounted) {
            showSnackBar(context, res, true);
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
          // username account
          TextFormField(
            controller: usernameController,
            focusNode: usernameFocus,
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
              helperStyle: const TextStyle(color: errorRedColor, fontSize: 14),
              // outline boder
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: isAccountState == IS_CORRECT_STATE
                        ? correctGreenColor
                        : isAccountState == IS_ERROR_STATE
                            ? errorRedColor
                            : defaultColor),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              suffixIcon: isAccountState == IS_DEFAULT_STATE
                  ? null
                  : isAccountState == IS_CORRECT_STATE
                      ? correctIcon
                      : errorIcon,
            ),
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(passwordFocus),
          ),
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
                borderSide: BorderSide(
                    color: isPasswordState == IS_ERROR_STATE
                        ? errorRedColor
                        : defaultColor),
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
            onEditingComplete: () {},
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
                        InkWell(
                          onTap: updateGroup,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              color: focusBlueColor,
                            ),
                            width: 48,
                            height: 32,
                            child: const Center(
                                child: Text(
                              "Tạo",
                              style: TextStyle(fontSize: 14),
                            )),
                          ),
                        ),
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
                        DropdownButton(
                          menuMaxHeight: 200,
                          alignment: Alignment.center,
                          value: groupSelect,
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
                                    color: (value == groupSelect)
                                        ? notifyIconColor
                                        : backgroundWhiteColor),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              groupSelect = val!;
                            });
                          },
                        ),
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
        InkWell(
          onTap: createStaff,
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
              "Tạo",
            )),
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pop(groups),
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
