import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/locator.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';

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
  WebblenBaseViewModel _webblenBaseViewModel = locator<WebblenBaseViewModel>();
  DialogService _dialogService = locator<DialogService>();

  retrieveImageFromLibrary() async {
    File file;
    Uint8List imageByteMemory;
    FileReader fileReader = FileReader();
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      file = uploadInput.files.first;
      fileReader.readAsDataUrl(file);

      //file upload start listener
      fileReader.onLoadStart.listen((event) {
        if (file.size > 5000000) {
          _dialogService.showDialog(
            title: "Image Size Error",
            description: "Image size cannot be more than 5MB",
            barrierDismissible: true,
          );
          fileReader.abort();
        } else if (!(file.type == "image/jpg" || file.type == "image/jpeg" || file.type == "image/png")) {
          _dialogService.showDialog(
            title: "Image Upload Error",
            description: "Please upload a valid image",
            barrierDismissible: true,
          );
          fileReader.abort();
        }
      });

      //file upload progress listener
      fileReader.onProgress.listen((event) {
        double progress = event.loaded / event.total;
        _webblenBaseViewModel.setUploadProgress(progress);
      });

      //file upload end listener
      fileReader.onLoadEnd.listen((event) {
        String base64FileString = fileReader.result.toString().split(',')[1];
        imageByteMemory = base64Decode(base64FileString);
        _webblenBaseViewModel.setImgToUploadFile(file);
        _webblenBaseViewModel.setImgToUploadByteMemory(imageByteMemory);
      });
    });
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
