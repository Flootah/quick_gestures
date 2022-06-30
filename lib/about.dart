import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AboutPage> createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  static const Color paper = Color(0xffeadece);
  static const Color ink = Color(0xff111111);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: const <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              "QuickGestures",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: ink,
              ),
            ),
            Text(
              '\nA tool for artists to practice quick gesture drawings.', textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Code, sketches, and design:\n\n'
                  'Ed "flootah" Saenz',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}