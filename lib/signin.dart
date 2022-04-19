import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widget.dart';
import 'package:flutter_svg/svg.dart';

import 'helper/helper.dart';
import 'helper/theme.dart';
import 'mainScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late QuerySnapshot userInfoSnapshot;

  signIn() async {
    var status = await HelperFunctions.saveUserEmailSharedPreference(
        emailEditingController.text);
    setState(() {
      isLoading = true;
    });
    if (status) {
      await DatabaseMethods()
          .getUserInfo(emailEditingController.text)
          .then((val) {
        userInfoSnapshot = val;
        print(val.docs[0]['email']);
        HelperFunctions.saveUserEmailSharedPreference(
            userInfoSnapshot.docs[0]["email"]);
      });
    }

    authService
        .signInWithEmailAndPassword(
            emailEditingController.text, passwordEditingController.text)
        .then((val) {
      if (val != null) {
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(
            userInfoSnapshot.docs[0]["name"]);
        HelperFunctions.saveUserEmailSharedPreference(
            userInfoSnapshot.docs[0]["email"]);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailEditingController,
                    key: formKey,
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "Please enter a correct email address";
                    },
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("email"),
                  ),
                  TextFormField(
                    obscureText: true,
                    // key: formKey,
                    controller: passwordEditingController,
                    validator: (val) {
                      if ((val?.length)! < 6) {
                        return "Enter Password 6+ characters";
                      }
                    },
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("password"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Forgot Password?",
                      style: simpleTextStyle(),
                    )),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                signIn();
                // print("adadas");
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
                  "Sign In",
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
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Sign In with Google",
                style: TextStyle(fontSize: 17, color: CustomTheme.textColor),
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
                  "Don't have account? ",
                  style: simpleTextStyle(),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Register now",
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
