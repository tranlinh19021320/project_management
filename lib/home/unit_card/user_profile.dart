import 'package:flutter/material.dart';
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
  TextEditingController roleController = TextEditingController();

  late FocusNode emailFocus;
  late FocusNode detailNameFocus;

  bool isUpdateEmail = false;
  bool isUpdateDetailName = false;

  int isEmailState = IS_CORRECT_STATE;

  @override
  void initState() {
    super.initState();
    emailController.text = context.read<UserProvider>().getEmail();
    detailNameController.text = context.read<UserProvider>().getDetailName();
    usernameController.text = context.read<UserProvider>().getUsername();
    roleController.text = context.read<UserProvider>().getRole();

    emailFocus = FocusNode();
    emailFocus.addListener(() async {
      if (!emailFocus.hasFocus) {
        setState(() {
          isUpdateEmail = false;
        });
        isEmailState =
            await FirebaseMethods().checkAlreadyEmail(emailController.text);
        if (!isChangedEmail()) {
          isEmailState = IS_CORRECT_STATE;
        }
        if (isEmailState == IS_ERROR_STATE) {
          // showBottomSheet(context: context, builder: (context)=> Text("Email đã có người sử dụng"));
        }
        setState(() {});
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
    roleController.dispose();

    emailFocus.dispose();
    detailNameFocus.dispose();
  }

  isChangedEmail() {
    return (emailController.text != context.read<UserProvider>().getEmail());
  }

  isUpdate() {
    return (isChangedEmail() ||
        detailNameController.text !=
            context.watch<UserProvider>().getCurrentUser.nameDetails);
  }

  updateProfile() async {
    if (isEmailState == IS_CORRECT_STATE ||
        isEmailState == IS_DEFAULT_STATE && isUpdate()) {
      String res = await context
          .read<UserProvider>()
          .updateUser(emailController.text, detailNameController.text);
      if (context.mounted) {
        if (res == 'success') {
          Navigator.pop(context);
          showSnackBar(context, "Cập nhật thành công!", false);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //email text
          TextField(
            controller: emailController,
            focusNode: emailFocus,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                prefixText: "Email: ",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isEmailState == IS_ERROR_STATE ||
                                isEmailState == IS_ERROR_FORMAT_STATE
                            ? errorRedColor
                            : defaultColor)),
                suffixIcon: IconButton(
                  icon: isUpdateEmail
                      ? const Icon(Icons.update)
                      : const Icon(Icons.update_disabled),
                  onPressed: () {
                    setState(() {
                      isUpdateEmail = !isUpdateEmail;
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
                prefixIcon: const Icon(Icons.person_search),
                prefixText: "Họ và tên: ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: defaultColor)),
                suffixIcon: IconButton(
                  icon: isUpdateDetailName
                      ? const Icon(Icons.update)
                      : const Icon(Icons.update_disabled),
                  onPressed: () {
                    setState(() {
                      isUpdateDetailName = !isUpdateDetailName;
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
              prefixIcon: const Icon(Icons.person),
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
          //role text
          TextField(
            controller: roleController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.groups_sharp),
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
                onTap: () {},
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
    );
  }
}
