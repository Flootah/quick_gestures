//palette.dart
import 'package:flutter/material.dart';
class Palette {
  static const MaterialColor ink = MaterialColor(
    0xff111111, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff0f0f0f ),//10%
      100: Color(0xff0e0e0e),//20%
      200: Color(0xff0c0c0c),//30%
      300: Color(0xf0a0a0a),//40%
      400: Color(0xff733024),//50%
      500: Color(0xff090909),//60%
      600: Color(0xff070707),//70%
      700: Color(0xff030303),//80%
      800: Color(0xff020202),//90%
      900: Color(0xff000000),//100%
    },
  );
}