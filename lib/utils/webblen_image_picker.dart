import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/services/reactive/file_uploader/reactive_file_uploader_service.dart';

class WebblenImagePicker {
  final BuildContext? context;
  final double? ratioX;
  final double? ratioY;

  WebblenImagePicker({
    this.context,
    this.ratioX,
    this.ratioY,
  });

  ReactiveFileUploaderService _reactiveFileUploaderService = locator<ReactiveFileUploaderService>();
  DialogService? _dialogService = locator<DialogService>();

  retrieveImageFromLibrary() async {
    File file;
    Uint8List fileByteMemory;
    FileReader fileReader = FileReader();
    InputElement uploadInput = FileUploadInputElement() as InputElement;
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      file = uploadInput.files!.first;
      fileReader.readAsDataUrl(file);

      //file upload start listener
      fileReader.onLoadStart.listen((event) {
        if (file.size > 5000000) {
          _dialogService!.showDialog(
            title: "Image Size Error",
            description: "Image size cannot be more than 5MB",
            barrierDismissible: true,
          );
          fileReader.abort();
        } else if (!(file.type == "image/jpg" || file.type == "image/jpeg" || file.type == "image/png")) {
          _dialogService!.showDialog(
            title: "Image Upload Error",
            description: "Please upload a valid image",
            barrierDismissible: true,
          );
          fileReader.abort();
        } else {
          _reactiveFileUploaderService.updateUploadingFile(true);
        }
      });

      //file upload progress listener
      fileReader.onProgress.listen((event) {
        double progress = event.loaded! / event.total!;
        _reactiveFileUploaderService.updateUploadProgress(progress);
      });

      //file upload end listener
      fileReader.onLoadEnd.listen((event) {
        String base64FileString = fileReader.result.toString().split(',')[1];
        fileByteMemory = base64Decode(base64FileString);
        _reactiveFileUploaderService.updateFileToUpload(file);
        _reactiveFileUploaderService.updateFileToUploadByteMemory(fileByteMemory);
        _reactiveFileUploaderService.updateUploadingFile(false);
      });
    });
  }
}
