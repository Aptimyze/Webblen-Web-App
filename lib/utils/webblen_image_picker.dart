import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';

class WebblenImagePicker {
  final BuildContext context;
  final double ratioX;
  final double ratioY;

  WebblenImagePicker({
    this.context,
    this.ratioX,
    this.ratioY,
  });

  final ImagePicker _imagePicker = ImagePicker();

  Future<File> retrieveImageFromLibrary({double ratioX, double ratioY}) async {
    imageCache.clear();

    return null;
  }

  Future<File> retrieveImageFromCamera({double ratioX, double ratioY}) async {
    imageCache.clear();
    File img;
    final pickedFile = await _imagePicker.getImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null) {
      // img = File(pickedFile.path);
    }
    return img;
  }
}
