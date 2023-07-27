import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/init_screen/home_screen.dart';
import 'package:project_management/init_screen/login.dart';
import '../stateparams/utils.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late FocusNode emailFocus;
  late FocusNode accountFocus;
  late FocusNode passwordFocus;

  bool isLockedPassword = true;
  bool isLoading = false;

  int isEmailState = IS_DEFAULT_STATE;
  int isAccountState = IS_DEFAULT_STATE;
  int isPasswordState = IS_DEFAULT_STATE;

  @override
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    emailFocus.addListener(() {
      if (!emailFocus.hasFocus) {
        checkAlreadyEmail();
      } else {
        setState(() {
          isEmailState = IS_DEFAULT_STATE;
        });
      }
    });
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
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    accountController.dispose();
    passwordController.dispose();

    emailFocus.dispose();
    accountFocus.dispose();
    passwordFocus.dispose();
  }

  signUp() async {
    passwordFocus.unfocus();

    if (isEmailState == IS_CORRECT_STATE &&
        isAccountState == IS_CORRECT_STATE) {
      if (passwordController.text == "") {
        setState(() {
          isPasswordState = IS_ERROR_STATE;
        });
      } else {
        setState(() {
          isLoading = true;
        });
        String res = await FirebaseMethods().createUser(
            email: emailController.text,
            username: accountController.text,
            password: passwordController.text,
            isManager: true,
            nameDetails: accountController.text,
            role: "manager",
            managerId: '', // managerId is equaq to userId
            managerEmail: emailController.text);

        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          if (res == "success") {
            showSnackBar(context, "Đăng ký thành công!", false);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else {
            showSnackBar(context, res, true);
          }
        }
      }
    }
  }

  // check state of email text field
  checkAlreadyEmail() async {
    if (emailController.text == "") {
      setState(() {
        isEmailState = IS_DEFAULT_STATE;
      });
    } else if (!isValidEmail(emailController.text)) {
      setState(() {
        // email is invalid format
        isEmailState = IS_ERROR_FORMAT_STATE;
      });
      showSnackBar(context, "Lỗi định dạng Email!", true);
    } else {
      String userId =
          await FirebaseMethods().getUserIdFromAccount(emailController.text);

      if (userId == "") {
        setState(() {
          // email not registered yet
          isEmailState = IS_CORRECT_STATE;
        });
      } else {
        setState(() {
          // email registered
          isEmailState = IS_ERROR_STATE;
        });
      }
    }
  }

  // check state of account text field
  checkAlreadyAccount() async {
    if (accountController.text == "") {
      setState(() {
        isAccountState = IS_DEFAULT_STATE;
      });
    } else {
      String userId =
          await FirebaseMethods().getUserIdFromAccount(accountController.text);

      if (userId == "") {
        setState(() {
          //username not registered yet
          isAccountState = IS_CORRECT_STATE;
        });
      } else {
        setState(() {
          //username registered
          isAccountState = IS_ERROR_STATE;
        });
      }
    }
  }

  navigatrToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()));
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
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // email text field
                  TextFormField(
                    controller: emailController,
                    focusNode: emailFocus,
                    decoration: InputDecoration(
                      labelText: "Email",
                      //notify if email is error
                      helperText: isEmailState == IS_ERROR_STATE
                          ? "Email đã đăng ký!"
                          : isEmailState == IS_ERROR_FORMAT_STATE
                              ? "Lỗi định dạng Email!"
                              : "",
                      helperStyle:
                          const TextStyle(color: textErrorColor, fontSize: 14),

                      // outline boder
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: isEmailState == IS_CORRECT_STATE
                                ? notifCorrectColor
                                : isEmailState == IS_DEFAULT_STATE
                                    ? defaultTextFieldColor
                                    : notifErrorColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),

                      suffixIcon: isEmailState == IS_DEFAULT_STATE
                          ? null
                          : isEmailState == IS_CORRECT_STATE
                              ? correctIcon
                              : errorIcon,
                    ),
                    autofocus: true,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(accountFocus),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  //account text field
                  TextFormField(
                    controller: accountController,
                    focusNode: accountFocus,
                    decoration: InputDecoration(
                      labelText: "Tài khoản",
                      // notify if username is error
                      helperText: isAccountState == IS_ERROR_STATE
                          ? "Tài khoản đã đăng ký!"
                          : "",
                      helperStyle:
                          const TextStyle(color: textErrorColor, fontSize: 14),
                      // outline boder
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: isAccountState == IS_CORRECT_STATE
                                ? notifCorrectColor
                                : isAccountState == IS_ERROR_STATE
                                    ? notifErrorColor
                                    : defaultTextFieldColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
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

                  // password text field
                  TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu",

                      //notify if password is empty
                      helperText: isPasswordState == IS_ERROR_STATE
                          ? "Vui lòng nhập mật khẩu!"
                          : "",
                      helperStyle:
                          const TextStyle(color: textErrorColor, fontSize: 14),
                      //outline border
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: isPasswordState == IS_ERROR_STATE
                                ? notifErrorColor
                                : defaultTextFieldColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),

                      //icon lock
                      suffixIcon: IconButton(
                        icon: isLockedPassword
                            ? const Icon(Icons.lock_outline)
                            : const Icon(Icons.lock_open_outlined),
                        onPressed: () {
                          setState(() {
                            isLockedPassword = !isLockedPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: isLockedPassword,
                    onEditingComplete: () => signUp(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // sign up button
                  InkWell(
                    onTap: signUp,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: buttonGreenColor,
                      ),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: notifCorrectColor,
                              ),
                            )
                          : const Text(
                              "Đăng ký",
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  const Text(
                    "hoặc",
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  // navigator to sign up
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
                          style: TextStyle(
                              color: textLightBlueColor, fontSize: 20),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
