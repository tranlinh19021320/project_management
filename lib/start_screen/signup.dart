import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/home_screen.dart';
import 'package:project_management/start_screen/add_company.dart';
import 'package:project_management/start_screen/login.dart';
import 'package:uuid/uuid.dart';
import '../utils/utils.dart';

class Signup extends StatefulWidget {
  final String companyName;
  const Signup({super.key, required this.companyName});

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
        String companyId = const Uuid().v1();
        String res1 = await FirebaseMethods().createCompany(widget.companyName, companyId);
        String res2 = await FirebaseMethods().createUser(
            email: emailController.text,
            username: accountController.text,
            password: passwordController.text,
            nameDetails: accountController.text,
            photoURL: '',
            group: manager,
            companyId: companyId,
            companyName: widget.companyName,
            );
        String userId = await FirebaseMethods()
            .getUserIdFromAccount(accountController.text);

        setState(() {
          isLoading = false;
        });
        String res3 = await FirebaseMethods().loginWithUserId(userId: userId, password: passwordController.text);
        if (res1 == "success" && res2 == 'success' && res3 == 'sucess') {
          if (context.mounted) {
            showSnackBar(context, "Đăng ký thành công!", false);
            
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      userId: userId,
                    )));
          }
        } else {
          if (context.mounted) {
            showSnackBar(context, res1, true);
            showSnackBar(context, res2, true);
          }
        }
      }
    }
  }
  navigateToAddCompany() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AddCompany()));
  }
  navigateToLogin() {
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
            padding: const EdgeInsets.all(28.0),
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
                              : null,
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
                          : null,
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
                          : null,
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
                        onTap: navigateToLogin,
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
          ),
          floatingActionButton: IconButton(onPressed: navigateToAddCompany, icon: leftArrowIcon, highlightColor: correctGreenColor,),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          ),
    );
  }
}
