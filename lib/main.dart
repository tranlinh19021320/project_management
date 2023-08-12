import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management/home/home_screen.dart';
import 'package:project_management/start_screen/login.dart';
import 'package:project_management/utils/utils.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QLDA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: darkblueAppbarColor,
                color: backgroundWhiteColor,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const HomeScreen();
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
          }

          return const Login();
        },
      ),
    );
  }
}
