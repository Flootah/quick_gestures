import 'dart:io';

class Drawing  {
  File? image;
  int? length;

  Drawing(File f, int l) {
    image = f;
    length = l;
  }

  getImage() {
    return image;
  }

  getLength() {
    return length;
  }
}