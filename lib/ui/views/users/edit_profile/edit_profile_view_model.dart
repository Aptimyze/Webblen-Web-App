import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/auth/auth_service.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/common/firestore_storage_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/reactive/file_uploader/reactive_file_uploader_service.dart';
import 'package:webblen_web_app/services/reactive/webblen_user/reactive_webblen_user_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';
import 'package:webblen_web_app/utils/webblen_image_picker.dart';

class EditProfileViewModel extends ReactiveViewModel {
  AuthService _authService = locator<AuthService>();
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  UserDataService _userDataService = locator<UserDataService>();
  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();
  ReactiveFileUploaderService _reactiveFileUploaderService = locator<ReactiveFileUploaderService>();
  ReactiveWebblenUserService _reactiveWebblenUserService = locator<ReactiveWebblenUserService>();
  FirestoreStorageService _firestoreStorageService = locator<FirestoreStorageService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();

  TextEditingController usernameTextController = TextEditingController();
  TextEditingController bioTextController = TextEditingController();
  TextEditingController websiteTextController = TextEditingController();

  bool updatingData = false;

  ///USER DATA
  bool? hasEarningsAccount;
  bool get isLoggedIn => _reactiveWebblenUserService.userLoggedIn;
  WebblenUser get user => _reactiveWebblenUserService.user;

  ///FILE DATA
  bool get uploadingFile => _reactiveFileUploaderService.uploadingFile;
  double get uploadProgress => _reactiveFileUploaderService.uploadProgress;
  File get fileToUpload => _reactiveFileUploaderService.fileToUpload;
  Uint8List get fileToUploadByteMemory => _reactiveFileUploaderService.fileToUploadByteMemory;

  String? updatedBio;
  String initialProfilePicURL = "";
  String initialProfileBio = "";
  String initialWebsiteLink = "";

  ///REACTIVE SERVICES
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_reactiveWebblenUserService, _reactiveFileUploaderService];

  initialize() async {
    setBusy(true);
    _reactiveFileUploaderService.clearUploaderData();
    usernameTextController.text = user.username ?? "";
    initialProfilePicURL = user.profilePicURL ?? "";
    bioTextController.text = user.bio ?? "";
    websiteTextController.text = user.website ?? "";
    notifyListeners();
    setBusy(false);
  }

  selectImage() async {
    WebblenImagePicker().retrieveImageFromLibrary();
  }

  websiteIsValid() {
    bool isValid = isValidUrl(websiteTextController.text.trim());
    if (!isValid) {
      _snackbarService.showSnackbar(
        title: 'Website Error',
        message: 'Please provide a valid website URL.',
        duration: Duration(seconds: 5),
      );
    }
    return isValid;
  }

  updateProfile() async {
    updatingData = true;
    notifyListeners();
    bool updateSuccessful = true;

    //upload img if exists
    if (fileToUploadByteMemory.isNotEmpty) {
      String imageURL = await _firestoreStorageService.uploadImage(imgFile: fileToUpload, storageBucket: 'images', folderName: 'users', fileName: user.id!);
      if (imageURL.isEmpty) {
        _customDialogService.showErrorDialog(
          description: "There was an issue updating your profile. Please try again.",
        );
        updatingData = false;
        notifyListeners();
        return false;
      }
      await _userDataService.updateProfilePicURL(id: user.id!, url: imageURL);
    }

    //update username
    if (user.username != usernameTextController.text) {
      String username = usernameTextController.text.trim().toLowerCase();
      if (isValidUsername(username)) {
        updateSuccessful = await _userDataService.updateUsername(username: username, id: user.id!);
      } else {
        _customDialogService.showErrorDialog(
          description: "Invalid Username",
        );
        updatingData = false;
        notifyListeners();
        return false;
      }
      if (!updateSuccessful) {
        updatingData = false;
        notifyListeners();
        return false;
      }
    }

    //update bio
    updateSuccessful = await _userDataService.updateBio(id: user.id, bio: bioTextController.text.trim());

    //update website link
    if (websiteTextController.text.trim().isNotEmpty) {
      if (websiteIsValid()) {
        updateSuccessful = await _userDataService.updateWebsite(id: user.id, website: websiteTextController.text.trim());
      } else {
        updateSuccessful = false;
      }
    } else if (websiteTextController.text.trim().isEmpty) {
      updateSuccessful = await _userDataService.updateWebsite(id: user.id, website: websiteTextController.text.trim());
    }

    if (updateSuccessful) {
      _reactiveFileUploaderService.clearUploaderData();
      navigateBack();
    } else {
      updatingData = false;
      notifyListeners();
    }
  }

  ///NAVIGATION
  navigateBack() {
    _navigationService.back();
  }
}
