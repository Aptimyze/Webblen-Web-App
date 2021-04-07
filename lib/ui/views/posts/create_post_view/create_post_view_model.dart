import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/app/app.router.dart';
import 'package:webblen_web_app/enums/bottom_sheet_type.dart';
import 'package:webblen_web_app/enums/post_type.dart';
import 'package:webblen_web_app/models/webblen_post.dart';
import 'package:webblen_web_app/services/firestore/common/firestore_storage_service.dart';
import 'package:webblen_web_app/services/firestore/data/platform_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/services/firestore/data/user_data_service.dart';
import 'package:webblen_web_app/services/location/location_service.dart';
import 'package:webblen_web_app/ui/views/base/webblen_base_view_model.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';
import 'package:webblen_web_app/utils/webblen_image_picker.dart';

class CreatePostViewModel extends BaseViewModel {
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  PlatformDataService _platformDataService = locator<PlatformDataService>();
  UserDataService _userDataService = locator<UserDataService>();
  LocationService _locationService = locator<LocationService>();
  FirestoreStorageService _firestoreStorageService = locator<FirestoreStorageService>();
  PostDataService _postDataService = locator<PostDataService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  WebblenBaseViewModel webblenBaseViewModel = locator<WebblenBaseViewModel>();

  ///HELPERS
  TextEditingController postTextController = TextEditingController();
  TextEditingController tagTextController = TextEditingController();
  bool textFieldEnabled = true;

  ///DATA
  String id;
  bool isEditing = false;
  double uploadProgress;
  File imgToUpload;
  Uint8List imgToUploadByteMemory;

  WebblenPost post = WebblenPost();

  ///WEBBLEN CURRENCY
  double newPostTaxRate;
  double promo;

  ///INITIALIZE
  initialize(String postID) async {
    setBusy(true);
    // .value will return the raw string value
    id = postID;
    //check if editing existing post
    if (id != null) {
      WebblenPost existingPost = await _postDataService.getPostToEditByID(id);
      if (existingPost != null) {
        post = existingPost;
        postTextController.text = post.body;
        isEditing = true;
      }
    }

    // listener for uploader
    webblenBaseViewModel.addListener(() {
      bool uploadStatusChanged = false;
      if (uploadProgress != webblenBaseViewModel.uploadProgress) {
        uploadStatusChanged = true;
        uploadProgress = webblenBaseViewModel.uploadProgress;
      }
      if (imgToUpload != webblenBaseViewModel.imgToUpload) {
        uploadStatusChanged = true;
        imgToUpload = webblenBaseViewModel.imgToUpload;
      }
      if (imgToUploadByteMemory != webblenBaseViewModel.imgToUploadByteMemory) {
        uploadStatusChanged = true;
        imgToUploadByteMemory = webblenBaseViewModel.imgToUploadByteMemory;
      }
      if (uploadStatusChanged) {
        notifyListeners();
      }
    });

    //get webblen rates
    newPostTaxRate = await _platformDataService.getNewPostTaxRate();
    if (newPostTaxRate == null) {
      newPostTaxRate = 0.05;
    }
    notifyListeners();
    setBusy(false);
  }

  ///POST TAGS
  addTag(String tag) {
    List tags = post.tags == null ? [] : post.tags.toList(growable: true);

    //check if tag already listed
    if (!tags.contains(tag)) {
      //check if tag limit has been reached
      if (tags.length == 3) {
        _dialogService.showDialog(
          title: "Tag Limit Reached",
          description: "You can only add up to 3 tags for your post",
        );
      } else {
        //add tag
        tags.add(tag);
        post.tags = tags;
        notifyListeners();
      }
    }
    tagTextController.clear();
  }

  removeTagAtIndex(int index) {
    List tags = post.tags == null ? [] : post.tags.toList(growable: true);
    tags.removeAt(index);
    post.tags = tags;
    notifyListeners();
  }

  ///POST LOCATION
  Future<bool> setPostLocation() async {
    bool success = true;

    //get current zip
    String zip = webblenBaseViewModel.areaCode;
    print(zip);
    if (zip == null) {
      return false;
    }

    //get nearest zipcodes
    post.nearbyZipcodes = await _locationService.findNearestZipcodes(zip);
    if (post.nearbyZipcodes == null) {
      return false;
    }

    //get city
    post.city = webblenBaseViewModel.cityName;
    print(post.city);

    //get province
    post.province = await _locationService.getProvinceFromZip(zip);
    if (post.province == null) {
      return false;
    }

    return success;
  }

  ///FORM VALIDATION
  bool postBodyIsValid() {
    String message = postTextController.text;
    return isValidString(message);
  }

  bool postTagsAreValid() {
    if (post.tags == null || post.tags.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool formIsValid() {
    bool isValid = false;
    if (!postTagsAreValid()) {
      _dialogService.showDialog(
        title: "Tag Error",
        description: "Your post must contain at least 1 tag",
      );
    } else if (!postBodyIsValid()) {
      _dialogService.showDialog(
        title: 'Post Message Required',
        description: 'The message for your post cannot be empty',
      );
    } else {
      isValid = true;
    }
    return isValid;
  }

  Future<bool> submitNewPost() async {
    bool success = true;

    //get current location
    bool setLocation = await setPostLocation();
    if (!setLocation) {
      _dialogService.showDialog(
        title: 'Location Error',
        description: 'There was an issue posting to your location. Please try again.',
      );
      return false;
    }

    String message = postTextController.text.trim();

    //generate new post
    post = WebblenPost(
      id: id,
      parentID: null,
      authorID: webblenBaseViewModel.uid,
      imageURL: null,
      body: message,
      nearbyZipcodes: post.nearbyZipcodes,
      city: post.city,
      province: post.province,
      followers: webblenBaseViewModel.user.followers,
      tags: post.tags,
      webAppLink: "https://app.webblen.io/posts/post?id=$id",
      sharedComs: [],
      savedBy: [],
      postType: PostType.eventPost,
      postDateTimeInMilliseconds: DateTime.now().millisecondsSinceEpoch,
      paidOut: false,
      participantIDs: [],
      commentCount: 0,
      reported: false,
      suggestedUIDs: post.suggestedUIDs == null ? webblenBaseViewModel.user.followers : post.suggestedUIDs,
    );

    //upload img if exists
    if (imgToUpload != null) {
      String imageURL = await _firestoreStorageService.uploadImage(imgFile: imgToUpload, storageBucket: 'images', folderName: 'posts', fileName: post.id);
      if (imageURL == null) {
        _dialogService.showDialog(
          title: 'Post Upload Error',
          description: 'There was an issue uploading your post. Please try again.',
        );
        return false;
      }
      post.imageURL = imageURL;
    }

    //upload post data
    var uploadResult = await _postDataService.createPost(post: post);
    if (uploadResult is String) {
      _dialogService.showDialog(
        title: 'Post Upload Error',
        description: 'There was an issue uploading your post. Please try again.',
      );
      return false;
    }

    return success;
  }

  Future<bool> submitEditedPost() async {
    bool success = true;

    String message = postTextController.text.trim();

    //update post
    post = WebblenPost(
      id: post.id,
      parentID: post.parentID,
      authorID: webblenBaseViewModel.uid,
      imageURL: imgToUploadByteMemory == null ? post.imageURL : null,
      body: message,
      nearbyZipcodes: post.nearbyZipcodes,
      city: post.city,
      province: post.province,
      followers: webblenBaseViewModel.user.followers,
      tags: post.tags,
      webAppLink: post.webAppLink,
      sharedComs: post.sharedComs,
      savedBy: post.savedBy,
      postType: PostType.eventPost,
      postDateTimeInMilliseconds: post.postDateTimeInMilliseconds,
      paidOut: post.paidOut,
      participantIDs: post.participantIDs,
      commentCount: post.commentCount,
      reported: post.reported,
      suggestedUIDs: post.suggestedUIDs == null ? webblenBaseViewModel.user.followers : post.suggestedUIDs,
    );

    //upload img if exists
    if (imgToUpload != null) {
      String imageURL = await _firestoreStorageService.uploadImage(imgFile: imgToUpload, storageBucket: 'images', folderName: 'posts', fileName: post.id);
      if (imageURL == null) {
        _dialogService.showDialog(
          title: 'Post Upload Error',
          description: 'There was an issue uploading your post. Please try again.',
        );
        return false;
      }
      post.imageURL = imageURL;
    }

    //upload post data
    var uploadResult = await _postDataService.updatePost(post: post);
    if (uploadResult is String) {
      _dialogService.showDialog(
        title: 'Post Upload Error',
        description: 'There was an issue uploading your post. Please try again.',
      );
      return false;
    }

    return success;
  }

  submitForm() async {
    setBusy(true);
    //check uploader
    if (uploadProgress != null && webblenBaseViewModel.uploadProgress != 1) {
      _dialogService.showDialog(
        title: 'Image Uploading',
        description: 'Your image is still being uploaded. Please wait',
      );
      setBusy(false);
      return;
    }

    //if editing update post, otherwise create new post
    if (isEditing) {
      //update post
      bool submittedPost = await submitEditedPost();
      if (submittedPost) {
        //show bottom sheet
        displayUploadSuccessBottomSheet();
      }
    } else {
      //submit new post
      bool submittedPost = await submitNewPost();
      if (submittedPost) {
        //show bottom sheet
        displayUploadSuccessBottomSheet();
      }
    }

    setBusy(false);
  }

  ///BOTTOM SHEETS
  selectImage() async {
    WebblenImagePicker().retrieveImageFromLibrary();
  }

  showNewContentConfirmationBottomSheet({BuildContext context}) async {
    //exit function if form is invalid
    if (!formIsValid()) {
      setBusy(false);
      return;
    }

    //check if editing post
    if (isEditing) {
      submitForm();
      return;
    }

    //display post confirmation
    var sheetResponse = await _bottomSheetService.showCustomSheet(
      barrierDismissible: true,
      title: "Publish Post?",
      description: "Publish this post for everyone to see",
      mainButtonTitle: "Publish Post",
      secondaryButtonTitle: "Cancel",
      customData: {'fee': newPostTaxRate, 'promo': promo},
      variant: BottomSheetType.newContentConfirmation,
    );
    if (sheetResponse != null) {
      String res = sheetResponse.responseData;

      //disable text fields while fetching image
      textFieldEnabled = false;
      notifyListeners();

      //get image from camera or gallery
      if (res == "insufficient funds") {
        _dialogService.showDialog(
          title: 'Insufficient Funds',
          description: 'You do no have enough WBLN to publish this post',
        );
      } else if (res == "confirmed") {
        submitForm();
      }

      //wait a bit to re-enable text fields
      await Future.delayed(Duration(milliseconds: 500));
      textFieldEnabled = true;
      notifyListeners();
    }
  }

  displayUploadSuccessBottomSheet() async {
    //deposit and/or withdraw webblen & promo
    if (promo != null) {
      await _userDataService.depositWebblen(uid: webblenBaseViewModel.uid, amount: promo);
    }
    await _userDataService.withdrawWebblen(uid: webblenBaseViewModel.uid, amount: newPostTaxRate);

    //display success
    var sheetResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.addContentSuccessful,
        takesInput: false,
        customData: post,
        barrierDismissible: false,
        title: isEditing ? "Your Post has been Updated" : "Your Post has been Published! 🎉");

    if (sheetResponse == null || sheetResponse.responseData == "done") {
      webblenBaseViewModel.clearUploaderData();
      _navigationService.pushNamedAndRemoveUntil(Routes.WebblenBaseViewRoute);
    }
  }
}
