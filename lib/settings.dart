import 'package:flutter/material.dart';
import 'package:quick_gestures/util/user_simple_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  static const Color paper = Color(0xffeadece);
  static const Color ink = Color(0xff111111);
  late bool shuffle;
  late bool grid;
  late bool flip_h;
  late bool flip_v;



  @override
  void initState() {
    super.initState();

    shuffle = UserSimplePreferences.getBool("shuffle") ?? false;
    grid = UserSimplePreferences.getBool("grid") ?? false;
    flip_h = UserSimplePreferences.getBool("flip_h") ?? false;
    flip_v = UserSimplePreferences.getBool("flip_v") ?? false;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

      ),
      body:
          SettingsList(
            sections: [
              SettingsSection(
                title: Text('Display'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      setState(() {
                        shuffle = value;
                        UserSimplePreferences.setBool("shuffle", shuffle);
                      });
                    },
                    initialValue: shuffle,
                    leading: Icon(Icons.format_paint),
                    title: Text('Shuffle'),
                    description: Text("Randomize display order of images in folder"),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      setState(() {
                        grid = value;
                        UserSimplePreferences.setBool("grid", grid);
                      });
                    },
                    initialValue: grid,
                    leading: Icon(Icons.format_paint),
                    title: Text('Show Grid'),
                    description: Text("Show grid overlay to help with reference."),
                  ),
                ],
              ),

              SettingsSection(
                title: Text('Image Flipping'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      setState(() {
                        flip_h = value;
                        UserSimplePreferences.setBool("flip_h", flip_h);
                      });
                    },
                    initialValue: flip_h,
                    leading: Icon(Icons.format_paint),
                    title: Text('Flip Horizontally'),
                    description: Text("Randomly flip images horizonally for variety."),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {
                      setState(() {
                        flip_v = value;
                        UserSimplePreferences.setBool("flip_v", flip_v);
                      });
                    },
                    initialValue: flip_v,
                    leading: Icon(Icons.format_paint),
                    title: Text('Flip Vertically'),
                    description: Text("Randomly flip images vertically for variety."),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}