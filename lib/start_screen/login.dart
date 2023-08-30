import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/home_screen.dart';
import 'package:project_management/start_screen/add_company.dart';
import 'package:project_management/utils/utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late FocusNode accountFocus;
  late FocusNode passwordFocus;

  bool isLockedPassword = true;
  bool isLoading = false;

  int isAccountState = IS_DEFAULT_STATE;
  int isPasswordState = IS_DEFAULT_STATE;

  @override
  void initState() {
    super.initState();
    accountFocus = FocusNode();
    accountFocus.addListener(() {
      if (!accountFocus.hasFocus) {
        checkAlreadyAccount();
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
      } else if (passwordController.text == "") {
        setState(() {
          isPasswordState = IS_ERROR_FORMAT_STATE;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    accountController.dispose();
    passwordController.dispose();

    accountFocus.dispose();
    passwordFocus.dispose();
  }

// log in funtion
  logIn() async {
    passwordFocus.unfocus();
    if (isAccountState == IS_CORRECT_STATE) {
      if (passwordController.text == "") {
        setState(() {
          isPasswordState = IS_ERROR_FORMAT_STATE;
        });
      } else {
        setState(() {
          isLoading = true;
        });
        String userId = await FirebaseMethods()
            .getUserIdFromAccount(account: accountController.text);
        String res = await FirebaseMethods().loginWithUserId(
          userId: userId,
        );

        if (context.mounted) {
          // log in completely
          if (res == "success") {
            if (context.mounted) {
              showSnackBar(context: context, content: "Đăng nhập thành công!",);

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            }
          }

          // error password
          else {
            setState(() {
              isPasswordState = IS_ERROR_STATE;
            });
            // showSnackBar(context, res, true);
          }
        }

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  checkAlreadyAccount() async {
    if (accountController.text == "") {
      setState(() {
        isAccountState = IS_DEFAULT_STATE;
      });
    } else {
      String userId = await FirebaseMethods()
          .getUserIdFromAccount(account: accountController.text);
      if (userId == "") {
        setState(() {
          isAccountState = IS_ERROR_STATE;
        });
      } else {
        setState(() {
          isAccountState = IS_CORRECT_STATE;
        });
      }
    }
  }

  navigateToSignup() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AddCompany()));
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
            padding: const EdgeInsets.all(28.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // account text field
                    TextFormField(
                      controller: accountController,
                      focusNode: accountFocus,
                      decoration: InputDecoration(
                        labelText: "Tài khoản hoặc Email",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: usernameIcon,
                        ),

                        // notify if error email
                        helperText: isAccountState == IS_ERROR_STATE
                            ? "Không tìm thấy tài khoản!"
                            : null,
                        helperStyle:
                            const TextStyle(color: errorRedColor, fontSize: 14),

                        // outline boder
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: notifyColor(state: isAccountState)),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6)),

                        suffixIcon: isAccountState == IS_DEFAULT_STATE
                            ? null
                            : isAccountState == IS_CORRECT_STATE
                                ? correctIcon
                                : errorIcon,
                      ),
                      autofocus: true,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(passwordFocus),
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    // password text field
                    TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: passwordIcon,
                        ),
                        // notify if password is error
                        helperText: isPasswordState == IS_ERROR_STATE
                            ? "Sai mật khẩu!"
                            : isPasswordState == IS_ERROR_FORMAT_STATE
                                ? "Vui lòng nhập mật khẩu"
                                : null,
                        helperStyle:
                            const TextStyle(color: errorRedColor, fontSize: 14),

                        //outline border
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: notifyColor(state: isPasswordState)),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6)),

                        suffixIcon: IconButton(
                          icon: isLockedPassword
                              ? hidePasswordIcon
                              : viewPasswordIcon,
                          onPressed: () {
                            setState(() {
                              isLockedPassword = !isLockedPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: isLockedPassword,
                      onEditingComplete: () => logIn(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),

                    // login button
                    InkWell(
                      onTap: logIn,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: buttonGreenColor,
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: correctGreenColor,
                                ),
                              )
                            : const Text(
                                "Đăng nhập",
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    const Text(
                      "hoặc",
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    // navigator to sign up
                    InkWell(
                      onTap: navigateToSignup,
                      child: const Text(
                        "Đăng ký như người quản lý",
                        style:
                            TextStyle(color: textLightBlueColor, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
