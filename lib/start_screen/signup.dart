import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/home_screen.dart';
import 'package:project_management/start_screen/login.dart';
import '../model/user.dart';
import '../utils/utils.dart';

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
    emailFocus.addListener(() async {
      if (!emailFocus.hasFocus) {
        isEmailState =
            await FirebaseMethods().checkAlreadyEmail(emailController.text);
        setState(() {});
      } else {
        setState(() {
          isEmailState = IS_DEFAULT_STATE;
        });
      }
    });
    accountFocus = FocusNode();
    accountFocus.addListener(() async {
      if (!accountFocus.hasFocus) {
        isAccountState =
            await FirebaseMethods().checkAlreadyAccount(accountController.text);
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
        String userId = await FirebaseMethods()
            .getUserIdFromAccount(accountController.text);

        setState(() {
          isLoading = false;
        });

        if (res == "success") {
          CurrentUser currentUser =
              await FirebaseMethods().getCurrentUserByUserId(userId);
          if (context.mounted) {
            showSnackBar(context, "Đăng ký thành công!", false);
            initStateProvider(context, userId);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      isManager: currentUser.isManager,
                    )));
          }
        } else {
          if (context.mounted) {
            showSnackBar(context, res, true);
          }
        }
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
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: emailIcon,
                      ),
                      //notify if email is error
                      helperText: isEmailState == IS_ERROR_STATE
                          ? "Email đã đăng ký!"
                          : isEmailState == IS_ERROR_FORMAT_STATE
                              ? "Lỗi định dạng Email!"
                              : "",
                      helperStyle:
                          const TextStyle(color: errorRedColor, fontSize: 14),

                      // outline boder
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: isEmailState == IS_CORRECT_STATE
                                ? correctGreenColor
                                : isEmailState == IS_DEFAULT_STATE
                                    ? defaultColor
                                    : errorRedColor),
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
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: usernameIcon,
                      ),
                      // notify if username is error
                      helperText: isAccountState == IS_ERROR_STATE
                          ? "Tài khoản đã đăng ký!"
                          : "",
                      helperStyle:
                          const TextStyle(color: errorRedColor, fontSize: 14),
                      // outline boder
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: isAccountState == IS_CORRECT_STATE
                                ? correctGreenColor
                                : isAccountState == IS_ERROR_STATE
                                    ? errorRedColor
                                    : defaultColor),
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
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: passwordIcon,
                      ),

                      //notify if password is empty
                      helperText: isPasswordState == IS_ERROR_STATE
                          ? "Vui lòng nhập mật khẩu!"
                          : "",
                      helperStyle:
                          const TextStyle(color: errorRedColor, fontSize: 14),
                      //outline border
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: isPasswordState == IS_ERROR_STATE
                                ? errorRedColor
                                : defaultColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),

                      //icon lock
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
                                color: correctGreenColor,
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
