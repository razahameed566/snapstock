import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/helper.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widget.dart';
import 'package:flutter_svg/svg.dart';
import 'helper/helper.dart';
import 'helper/theme.dart';
import 'mainScreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();

  bool isLoading = false;
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController usernameEditingController = TextEditingController();

  singUp() async {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfoMap = {
        "name": usernameEditingController.text,
        "email": emailEditingController.text,
      };

      // HelperFunctions.saveUserEmailSharedPreference(
      //     emailEditingController.text);

      // HelperFunctions.saveUserNameSharedPreference(
      //     usernameEditingController.text);

      setState(() {
        isLoading = true;
      });

      await authService
          .signUpWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "userName": usernameEditingController.text,
            "userEmail": emailEditingController.text
          };

          databaseMethods.addUserInfo(userInfoMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        } else {
          return ("PLease Enter Details");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff787878),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SvgPicture.asset(
          "assets/SnapStock_Horizontal.svg",
          height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty || val.length < 4) {
                              return "Please enter a correct user name";
                            }
                          },
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("username"),
                          controller: usernameEditingController,
                        ),
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a correct email address";
                          },
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("email"),
                          controller: emailEditingController,
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            if ((val?.length)! < 6) {
                              return "Please enter a Password of 6+ characters";
                            }
                          },
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("password"),
                          controller: passwordEditingController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      singUp();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xffF1941F), Color(0xffF1950F)],
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Sign Up",
                        style: biggerTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Sign Up with Google",
                      style:
                          TextStyle(fontSize: 17, color: CustomTheme.textColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ALready have account? ",
                        style: simpleTextStyle(),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "SignIn Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
    );
  }
}
