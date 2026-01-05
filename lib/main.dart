import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/my_theme_data.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyB1vHqaf54TkHQlmJzmDGsQDS3nD1Hnq7Q',
          appId: 'com.example.todo_app',
          messagingSenderId: '991211976340',
          projectId: 'todo-app-ab27d'
      )
  )
      :

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {HomeScreen.routeName: (context) => HomeScreen()},
      theme: MyThemeData.lightTheme,
    );
  }
}
