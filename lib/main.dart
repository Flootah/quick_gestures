import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_gestures/util/user_simple_preferences.dart';

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

  // runs app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Quick Gestures',
      // TODO implement proper theming
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Palette.ink,
      ),
      home: const HomePage(title: "home page"),
    );
  }
}

