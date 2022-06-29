import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_gestures/util/user_simple_preferences.dart';
import 'dart:convert';
import 'package:json_theme/json_theme.dart';

// pages
import 'home.dart';
import 'util/palette.dart';

void main() async {
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  // removes status bar shadow
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Palette.ink,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized(); // stops error
  await UserSimplePreferences.init();
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson);
  // runs app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color paper = Color(0xffeadece);
  static const Color ink = Color(0xff111111);

  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Gestures',
      home: const HomePage(title: "home page"),
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: ink),
            ),
          ),
        cardColor: paper,
        cardTheme: CardTheme(

        ),
        textTheme: TextTheme(

        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 20, color: ink),
          iconTheme: IconThemeData(
            color: ink,
          ),
          backgroundColor: paper,
          elevation: 0,
        ),
        primaryColor: paper,
        primaryColorLight: paper,
        scaffoldBackgroundColor: paper,
        splashColor: ink,
        backgroundColor: paper,
        canvasColor: paper,
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return ink;
            }
            if (states.contains(MaterialState.disabled)) {
              return paper;
            }
            return paper;
          }),
          trackColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return ink.withOpacity(0.6);
            }
            if (states.contains(MaterialState.disabled)) {
              return ink.withOpacity(0.3);
            }
            return ink.withOpacity(0.2);
          }),
        ),
        toggleButtonsTheme: ToggleButtonsThemeData(
          color: ink.withOpacity(0.8),
          selectedColor: ink,
          highlightColor: ink.withOpacity(0.3),
          splashColor: ink.withOpacity(0.3),
          fillColor: ink.withOpacity(0.3)
        )
        ),
      );
  }
}

