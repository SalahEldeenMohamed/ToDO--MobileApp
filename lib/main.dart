import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/my_theme_data.dart';
import 'package:todo_app/providers/app_config_provider.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/settings/settings_tab.dart';

import 'home_screen.dart';
import 'l10n/app_localizations.dart';

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
  await Firebase.initializeApp();
  await FirebaseFirestore.instance.disableNetwork();

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => AppConfigProvider()),
            ChangeNotifierProvider(
                create: (context) => ListProvider()),
          ],
      child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        SettingsTab.routeName: (context) => SettingsTab(),
      },
      theme: MyThemeData.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.appLanguage),
      themeMode: provider.appTheme,
      darkTheme: MyThemeData.darkTheme,
    );
  }
}
