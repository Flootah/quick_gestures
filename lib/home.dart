
// material
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glob/list_local_fs.dart';
import 'package:quick_gestures/util/user_simple_preferences.dart';
// other pages
import 'settings.dart';
import 'about.dart';
import 'session.dart';
// file i/o
import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:glob/glob.dart';
// permissions
import 'package:permission_handler/permission_handler.dart';
// ignore_for_file: prefer_const_constructors

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => HomePageState();

}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static const Color paper = Color(0xffeadece);
  static const Color ink = Color(0xff111111);
  // interval, class, relaxed, custom
  String mode = "interval";
  // announce tab controller
  late TabController _controller;
  int page = 0;
  // tab padding
  var tabPadding = EdgeInsets.fromLTRB(0, 30, 0, 30);
  // menu items for three dot
  var menuItems = <String>['Settings', "About"];
  // path from sharedpreferences
  String path = "";
  // chosen directory
  Directory dir = Directory("");
  // directory text
  String dirText = "";
  // images list
  List<File> images = List.empty();
  // interval selections
  List<bool> intSelections = [true, false, false, false, false, false];

  @override
  void initState() {
    intSelections[0] == true;
    // init main tab controller
    _controller = TabController(vsync: this, length: 4);
    _controller.addListener(() {
      setState(() {
          page = _controller.index;
      });
    });
    // set directory based on settings
    path = UserSimplePreferences.getString("path") ?? "";
    dir = Directory(path);
    // set text for thingy
    processDir();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // list of selections for interval mode



    final ButtonStyle bstyle =
    ElevatedButton.styleFrom(
        primary: ink,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0)
        ));

    return Scaffold(
      backgroundColor: paper,
      appBar: AppBar(
          backgroundColor: paper,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "QuickGestures",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: ink,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: ink),
              onSelected: (String choice) {
                switch (choice) {
                  case "Settings":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage(
                              title: "settings")),
                      // TODO add slide animation
                    );
                    break;
                  case "About":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage(
                          title: "about")),
                      // TODO add slide animation
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return menuItems.map((String choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Text(choice),

                  );
                }).toList();
              },
            ),
          ]
      ),
      body: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,


          children: <Widget>[
            Expanded(
              flex: 1,
              child: Image.asset("assets/gesture.png"),
            ),
            Expanded(
              flex: 1,
              //decoration: BoxDecoration(color: Colors.blue),
              //height: 500,
              child:
              Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: bstyle,
                          onPressed: () {
                            chooseDir();
                          },
                          child: Text("Choose Folder...", style: TextStyle(color: paper),),
                        ),
                        Text(dirText, textAlign: TextAlign.center,),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 60,
                    child:
                    TabBar(
                      labelColor: ink,
                      controller: _controller,
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.timer, color: ink,),
                          text: "Interval",
                          iconMargin: EdgeInsets.zero,
                        ),
                        Tab(
                          icon: Icon(Icons.school, color: ink),
                          text: "Class",
                          iconMargin: EdgeInsets.zero,
                        ),
                        Tab(
                          icon: Icon(Icons.brush, color: ink),
                          text: "Relaxed",
                          iconMargin: EdgeInsets.zero,
                        ),
                        Tab(
                          icon: Icon(Icons.edit_note, color: ink),
                          text: "Custom",
                          iconMargin: EdgeInsets.zero,
                        ),
                      ], // Tabs
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        Padding(
                          padding: tabPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 40,
                                child: ToggleButtons(
                                  onPressed: (int index) {
                                    setState(() {
                                      intSelections[index] = !intSelections[index];
                                      for (int buttonIndex = 0; buttonIndex < intSelections.length; buttonIndex++) {
                                        if (buttonIndex == index) {
                                          intSelections[buttonIndex] = true;
                                        } else {
                                          intSelections[buttonIndex] = false;
                                        }
                                      }
                                    });
                                  },
                                  isSelected: intSelections,

                                  children: const <Widget>[
                                    Text("10s"),
                                    Text("30s"),
                                    Text("1m"),
                                    Text("2m"),
                                    Text("5m"),
                                    Text("10m"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text("Draw with fixed time intervals.\n All images will change after a certain amount of time.", textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: tabPadding,
                              child: Text("Draw in a 1 hour session with varying intevals.\n Starting with 30s, working up to 10min.", textAlign: TextAlign.center,),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: tabPadding,
                              child: Text("Draw at your own pace. No timer!\n Change images whenever you choose.", textAlign: TextAlign.center,),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: tabPadding,
                              child: Text("Set custom intervals. Coming soon!", textAlign: TextAlign.center,),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
                height: 75,
                width: double.infinity,
                child:
                ElevatedButton(
                  onPressed: () {
                    if(images.isEmpty) {
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          SessionPage(images: images, sessionType: page, interval: getInterval(),)),
                      // TODO add slide animation
                    );
                  },
                  style: bstyle,
                  child:
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text("BEGIN", style: TextStyle(color: paper),),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // TODO better error handling.
  void chooseDir() async {
    String? path = "";
    path = await FilesystemPicker.open(
      title: 'Choose image folder',
      context: context,
      rootDirectory: Directory("storage/emulated/0/"),
      fsType: FilesystemType.folder,
      allowedExtensions: ['.jpg', 'jpeg', '.png'],
      pickText: 'Use this folder',
      folderIconColor: ink,
    ).onError((error, stackTrace) => path = "");

    UserSimplePreferences.setString("path", path ?? "");




    dir = Directory(path ?? "");
    //print("chosen path is $path");
    processDir();
    return;
  }

  Future<void> processDir() async {
    // if nothing selected, return so.
    if(dir.path == "") {
      setState(() {
        dirText = "No directory selected.";
      });
      return;
    } else if (dir.path == "storage/emulated/0/") {
      setState(() {
        dirText = "Invalid directory! Includes inaccessible root files.";
      });
      return;
    }
    // otherwise, process directory

    // get permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
      Permission.storage,
    ].request();

    if(await Permission.storage.request().isGranted) {
      //print("permission granted");
    } else {
      dirText = "Storage permissions denied. Please try again";
      return;
    }

    Future<List<File>> s = Glob("${dir.path}/**.{jpg, png, jpeg}")
                            .list(root: dir.path)
                            .where((entity) => entity is File)
                            .cast<File>().toList();

    // update loading text
    setState(() {
      dirText = "Loading...";
    });

    // prep images list and update text when finished
    images = await s;
    s.whenComplete(() => updateText());
  }

  Stream<File> fetchImg(Directory dir) {
    return Glob("${dir.path}/**.{png, jpg, jpeg}")
        .list(root: dir.path)
        .where((entity) => entity is File)
        .cast<File>();
  }

  void updateText() {
    //print("images: $images");
    String str = "";

    if(images.isEmpty || images == null) {
      str = "No images found in ${dir.path.split('/').last}!\n Please try another folder.";
    } else {
      str = "Folder: ${dir.path.split('/').last} \n"
          "Found ${images.length} images in folder";
    }

    setState(() {
      dirText = str;
    });
  }

  int getInterval() {
    int i = 0;
    for(; i < intSelections.length; i++) {
      if(intSelections[i] == true) {
        break;
      }
    }
    switch(i) {
      case 0:
        return 10;
      case 1:
        return 30;
      case 2:
        return 60;
      case 3:
        return 120;
      case 4:
        return 300;
      case 5:
        return 600;
    }
    return 30;
  }
}
  
