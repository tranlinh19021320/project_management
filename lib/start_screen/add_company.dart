import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/start_screen/login.dart';
import 'package:project_management/start_screen/signup.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  TextEditingController controller = TextEditingController();
  late FocusNode focusNode;
  int isAlreadyCompany = IS_DEFAULT_STATE;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        checkAlreadyCompany();
      }
    });
  }

  navigatrToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()));
  }

  navigateToSignup() {
    if (isAlreadyCompany == IS_CORRECT_STATE) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Signup(
              companyName: controller.text,
            )));
    } else if (isAlreadyCompany == IS_DEFAULT_STATE) {
      const NotifyDialog(content: ("Vui lòng nhập tên tổ chức!"), isError: true);
    } else {
      const NotifyDialog(content: ("Tên tổ chức đã đăng ký!!"), isError: true);
    }
  }

  checkAlreadyCompany() async {
    isAlreadyCompany =
        await FirebaseMethods().isAlreadyCompany(companyName: controller.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(backgroundImage), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(34.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tên tổ chức",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: groupIcon,
                    ),
                    //notify if email is error
                    helperText: isAlreadyCompany == IS_ERROR_STATE
                        ? "Tên tổ chức đã đăng ký!"
                        : null,
                    helperStyle:
                        const TextStyle(color: errorRedColor, fontSize: 14),

                    // outline boder
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isAlreadyCompany == IS_CORRECT_STATE
                              ? correctGreenColor
                              : isAlreadyCompany == IS_DEFAULT_STATE
                                  ? defaultColor
                                  : errorRedColor),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                    suffixIcon: isAlreadyCompany == IS_DEFAULT_STATE
                        ? null
                        : isAlreadyCompany == IS_CORRECT_STATE
                            ? correctIcon
                            : errorIcon,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                IconButton(
                  onPressed: navigateToSignup,
                  icon: rightArrowIcon,
                  highlightColor: correctGreenColor,
                ),
                const SizedBox(
                  height: 48,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Đã có tài khoản? ",
                      style: TextStyle(fontSize: 19),
                    ),
                    InkWell(
                      onTap: navigatrToLogin,
                      child: const Text(
                        "Đăng nhập",
                        style:
                            TextStyle(color: textLightBlueColor, fontSize: 20),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
