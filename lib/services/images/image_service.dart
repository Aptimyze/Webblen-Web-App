import 'dart:html';

class UploadImageService {
  Future<File> compressImage() async {
    File file;
    FileReader fileReader = FileReader();
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      file = uploadInput.files.first;
      fileReader.readAsDataUrl(file);
      fileReader.onLoadEnd.listen((event) {});
    });
    return file;
  }
}
