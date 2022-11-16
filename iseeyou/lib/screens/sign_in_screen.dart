import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iseeyou/backend/resources/firebase_auth_repository.dart';
import 'package:iseeyou/utils/universal_variables.dart';
import 'package:shimmer/shimmer.dart';

import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  FirebaseAuthRepository _repository = FirebaseAuthRepository();

  bool isSignInButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: Stack(
          children: [
            Center(
              child: signInButton(),
            ),
            isSignInButtonPressed
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        ));
  }

  Widget signInButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "Sign In",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        onPressed: () => performUserSignIn(),
      ),
    );
  }

  void performUserSignIn() {
    setState(() {
      isSignInButtonPressed = true;
    });

    _repository.signIn().then((User user) {
      if (user != null) {
        authUserWithGoogleCredentials(user);
      } else {
        print("Error");
      }
    });
  }

  void authUserWithGoogleCredentials(User user) {
    _repository.authenticateUser(user).then((isNewUser) {
      setState(() {
        isSignInButtonPressed = false;
      });
      if (isNewUser) {
        _repository.addUserDataToDB(user).then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }
}
