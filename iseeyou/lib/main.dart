import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iseeyou/backend/resources/firebase_auth_repository.dart';
import 'package:iseeyou/screens/home_screen.dart';
import 'package:iseeyou/screens/search_screen.dart';
import 'package:iseeyou/screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuthRepository _repository = FirebaseAuthRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "iSeeYou",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          'search_screen': (context) => SearchScreen(),
        },
        theme: ThemeData(brightness: Brightness.dark),
        home: FutureBuilder(
            future: _repository.getCurrentUser(),
            builder: (context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return HomeScreen();
              } else {
                return SignInScreen();
              }
            }));
  }
}
