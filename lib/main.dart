import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management/provider/page_provider.dart';
import 'package:project_management/provider/user_provider.dart';
import 'package:project_management/start_screen/login.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PageProvider()),
      ],
      child: MaterialApp(
        title: 'QLDA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const Login(),
      ),
    );
  }
}
