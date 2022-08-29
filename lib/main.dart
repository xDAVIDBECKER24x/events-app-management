import 'package:events_app_management/modules/home/screens/home_screen.dart';
import 'package:events_app_management/modules/welcome/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Plataform',
      home:  const WelcomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.grey,
        fontFamily: 'Georgia',
      ),
    );
  }
}

