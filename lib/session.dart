import 'dart:io';
import 'dart:math';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:quick_gestures/util/user_simple_preferences.dart';
import 'settings.dart';
import 'package:flutter/services.dart';
import 'util/drawing.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({Key? key, required this.images, required this.sessionType}) : super(key: key);

  final List<File> images;
  final int sessionType;

  @override
  State<SessionPage> createState() => SessionPageState();
}

class SessionPageState extends State<SessionPage> {
  static const Color paper = Color(0xffeadece);
  static const Color ink = Color(0xff111111);
  static const iconpadding = EdgeInsets.fromLTRB(20, 10, 20, 10);



  // timer controller
  CountDownController timeController = CountDownController();

  // interval for timer
  int interval = 0;

  // pause/unpause icon
  var pauseIcon = Icon(Icons.pause, color: paper);

  // image and current image index
  // list of drawings
  List<Drawing> drawings = [];
  int image_i = 0;
  late File curImg;

  // settings booleans
  late bool shuffle;
  late bool gridVisibility;
  late bool flip_h;
  late bool flip_v;

  // image scale for flipping
  double image_scale_x = 1;
  double image_scale_y = 1;

  // grid color
  var gridColor = ink.withOpacity(1);

  // TODO make toolbar hide/show

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // init booleans
    shuffle = UserSimplePreferences.getBool("shuffle") ?? false;
    gridVisibility = UserSimplePreferences.getBool("grid") ?? false;
    flip_h = UserSimplePreferences.getBool("flip_h") ?? false;
    flip_v = UserSimplePreferences.getBool("flip_v") ?? false;

    // init drawings list and current image
    drawings = makeDrawings(widget.images);

    //changeImg(0);
    curImg = drawings.elementAt(0).getImage();
    flipImage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
        clipBehavior: Clip.none,
        children: [

          /*********************** bg color  *********************/
          Container(
            color: paper,
          ),
          /*********************** image *********************/
          Transform.scale(
            scaleX: image_scale_x,
            scaleY: image_scale_y,
            child:
            Image.file(
              curImg,
              key: UniqueKey(),
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          /*********************** timer  *********************/
          Visibility(
            visible: widget.sessionType != 2,
            maintainState: true,
            maintainAnimation: false,
            child: CircularCountDownTimer(
              controller: timeController,
              duration: drawings.elementAt(image_i).getLength() ?? 99,
              width: 100,
              height: 100,
              strokeWidth: 20.0,
              fillColor: ink,
              ringColor: Colors.transparent,
              autoStart: true,
              isReverse: true,
              isTimerTextShown: true,
              onComplete: () {
                changeImg(1);
              },
            )
          ),
          /*********************** pause line *********************/
          Center(
            child: Visibility(
              visible: timeController.isPaused,
              child: Container (
                height: 60,
                width: double.infinity,
                color: ink.withOpacity(0.6),
                child: const Text("Paused", style: TextStyle(color: paper, ), textAlign: TextAlign.center,),
              ),
            ),
          ),
          /*********************** grid col *********************/
          Visibility(
            visible: gridVisibility,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: gridColor,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.33,
                    width: MediaQuery.of(context).size.width * 0.33,
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: gridColor,
                  ),
                ]
                ),
            ),
          ),
          /*********************** grid row *********************/
          Visibility(
            visible: gridVisibility,
            child: Center(
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: double.infinity,
                        width: 2,
                        color: gridColor,
                        alignment: Alignment.centerRight,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.33,
                        width: MediaQuery.of(context).size.width * 0.33,
                      ),

                      Container(
                        height: double.infinity,
                        width: 2,
                        color: gridColor,
                      ),
                    ]
                ),
              ),

            ),
          ),
          /*********************** controls *********************/
          Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar:
            BottomAppBar(
              color: ink,
              elevation: 75,
              child: SizedBox(
                height: 75,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          changeImg(-1);
                        },
                        padding: iconpadding,
                        icon: const Icon(Icons.chevron_left, color: paper)
                    ),
                    Visibility(
                      visible: widget.sessionType != 2,
                      maintainInteractivity: false,
                      maintainAnimation: true,
                      maintainState: true,
                      maintainSize: true,
                      child:
                      IconButton(
                          onPressed: () {
                            pauseTimer();
                          },
                          padding: iconpadding,
                          icon: pauseIcon,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          changeImg(1);
                        },
                        padding: iconpadding,
                        icon: const Icon(Icons.chevron_right, color: paper)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
    );
  }

  void changeImg(int val) {
      image_i += val;

      if (image_i == drawings.length) {
        image_i = 0;
      }
      if (image_i == -1) {
        image_i = drawings.length - 1;
      }

      // anticipate next image;
      int iplus = image_i + 1;

      if (iplus == drawings.length) {
        iplus = 0;
      }
      if (iplus == -1) {
        iplus = drawings.length - 1;
      }

      setState(() {
      // set curimg
      curImg = drawings[image_i].getImage();
      // restart time if started
      if(timeController.isStarted) {
        timeController.restart(duration: drawings[image_i].getLength());
      }

      // precache next image
      precacheImage(FileImage(drawings.elementAt(iplus).getImage()), context);
      // clear image cache to show updated images
      flipImage();
      clearImgCache();
    });
  }

  void flipImage() {
    // flip if neeeded
    if(flip_h) {
      if(Random().nextInt(2) == 1) {
        image_scale_x = -1;
      } else {
        image_scale_x = 1;
      }
    }
    if(flip_v) {
      if(Random().nextInt(2) == 1) {
        image_scale_y = -1;
      } else {
        image_scale_y = 1;
      }
    }
  }
  void pauseTimer() {
    setState(() {
      if(timeController.isPaused) {
        timeController.resume();
        pauseIcon = Icon(Icons.pause, color: paper);
        timeController.isPaused = false;
      } else {
        timeController.pause();
        pauseIcon = Icon(Icons.play_arrow, color: paper);
      }
    });
  }

  void clearImgCache() {
    setState(() {
      imageCache.clear();
    });
  }

  List<Drawing> makeDrawings(List<File> images) {
    List<Drawing> list = [];

    switch (widget.sessionType) {
      // interval
      case 0:
        for(int i = 0; i < images.length; i++)  {
          list.add(Drawing(images[i], 30));
          //TODO get interval from homepage
        }
        break;
      // class
      case 1:
      // 1hr
        list = make1hrClass(images);
        break;
      // relaxed
      case 2:
        for(int i = 0; i < images.length; i++)  {
          list.add(Drawing(images[i], 1));
        }
        break;
      // case 3:
      //
      //   //TODO implement customs
      //   break;
    }
    if(shuffle) {
      list.shuffle();
    }

    return list;
  }

  List<Drawing> make1hrClass(List<File> images) {
    List<Drawing> list = [];
    int i = 0;
    while (i < 20) {
      list.add(Drawing(images[i], 30));
      i++;
      if (i == images.length) {
        return list;
      }
    }
    while (i < 32) {
      list.add(Drawing(images[i], 45));
      i++;
      if (i == images.length) {
        return list;
      }
    }
    while (i < 38) {
      list.add(Drawing(images[i], 60));
      i++;
      if (i == images.length) {
        return list;
      }
    }
    while (i < 43) {
      list.add(Drawing(images[i], 120));
      i++;
      if (i == images.length) {
        return list;
      }
    }
    while (i < 46) {
      list.add(Drawing(images[i], 300));
      i++;
      if (i == images.length) {
        return list;
      }
    }
    while (i < 47) {
      list.add(Drawing(images[i], 600));
      i++;
      if (i == images.length) {
        return list;
      }
    }
    return list;
  }
}