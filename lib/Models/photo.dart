import 'dart:io';

import 'package:flutter/material.dart';

class Photo extends ChangeNotifier {
  File? photo;

  void modifyPhoto(File? newPhoto) {
    photo = newPhoto;
    notifyListeners();
  }
}
