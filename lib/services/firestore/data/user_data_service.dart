import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_user.dart';
import 'package:webblen_web_app/services/dialogs/custom_dialog_service.dart';
import 'package:webblen_web_app/services/firestore/common/firestore_storage_service.dart';

class UserDataService {
  CollectionReference userRef = FirebaseFirestore.instance.collection('webblen_users');
  CollectionReference postsRef = FirebaseFirestore.instance.collection('posts');
  FirestoreStorageService? _firestoreStorageService = locator<FirestoreStorageService>();
  SnackbarService? _snackbarService = locator<SnackbarService>();
  CustomDialogService _customDialogService = locator<CustomDialogService>();

  Future<bool?> checkIfUserExists(String? id) async {
    bool exists;
    DocumentSnapshot snapshot = await userRef.doc(id).get().catchError((e) {
      print(e.message);
    });

    if (snapshot.exists) {
      exists = true;
    } else {
      exists = false;
    }
    return exists;
  }

  Future<bool> checkIfUsernameExists(String username) async {
    bool usernameExists = false;
    QuerySnapshot snapshot = await userRef.where("username", isEqualTo: username).get();
    if (snapshot.docs.isNotEmpty) {
      usernameExists = true;
    }
    return usernameExists;
  }

  Future createWebblenUser(WebblenUser user) async {
    await userRef.doc(user.id).set(user.toMap()).catchError((e) {
      return e.message;
    });
  }

  FutureOr<WebblenUser> getWebblenUserByID(String? id) async {
    WebblenUser user = WebblenUser();
    String? error;
    DocumentSnapshot snapshot = await userRef.doc(id).get().catchError((e) {
      error = e.message;
    });
    if (error != null) {
      return user;
    }
    if (snapshot.exists) {
      user = WebblenUser.fromMap(snapshot.data()!);
    }
    return user;
  }

  Future<WebblenUser> getWebblenUserByUsername(String username) async {
    WebblenUser user = WebblenUser();
    String? error;
    QuerySnapshot querySnapshot = await userRef.where("username", isEqualTo: username).get().catchError((e) {
      //print(e.message)
      error = e.message;
    });
    if (error != null) {
      _customDialogService.showErrorDialog(description: error!);
      return user;
    }
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      Map<String, dynamic> docData = doc.data()!;
      user = WebblenUser.fromMap(docData);
    }
    return user;
  }

  Future<bool> updateWebblenUser(WebblenUser user) async {
    bool updated = true;
    String? error;
    await userRef.doc(user.id).update(user.toMap()).catchError((e) {
      error = e.message;
    });
    if (error != null) {
      updated = false;
    }
    return updated;
  }

  Future<bool> updateProfilePicURL({required String id, required String url}) async {
    bool updated = true;
    String? error;
    await userRef.doc(id).update({
      "profilePicURL": url,
    }).catchError((e) {
      error = e.message;
    });
    if (error != null) {
      updated = false;
    }
    return updated;
  }

  Future<bool> updateAssociatedEmailAddress(String uid, String emailAddress) async {
    bool updated = true;
    String? error;
    userRef.doc(uid).update({"emailAddress": emailAddress}).whenComplete(() {}).catchError((e) {
          error = e.message;
        });
    if (error != null) {
      updated = false;
    }
    return updated;
  }

  Future<bool> updateUsername({required String username, required String id}) async {
    bool updated = true;
    String? error;
    bool usernameExists = await checkIfUsernameExists(username);
    if (usernameExists) {
      _customDialogService.showErrorDialog(description: "Username already exists, please choose another.");
      updated = false;
    } else if (username.startsWith("user")) {
      _customDialogService.showErrorDialog(description: "invalid username");
      updated = false;
    } else {
      await userRef.doc(id).update({
        "username": username,
      }).catchError((e) {
        error = e.message;
      });
      if (error != null) {
        updated = false;
      }
    }

    return updated;
  }

  Future<bool> updateInterests(String uid, List tags) async {
    bool updated = true;
    String? error;
    await userRef.doc(uid).update({"tags": tags}).catchError((e) {
      error = e.message;
    });
    if (error != null) {
      updated = false;
    }
    return updated;
  }

  Future<bool> updateBio({String? id, String? bio}) async {
    bool updated = true;
    String? error;
    await userRef.doc(id).update({
      "bio": bio,
    }).catchError((e) {
      error = e.message;
    });
    if (error != null) {
      updated = false;
    }
    return updated;
  }

  Future<bool> updateWebsite({String? id, String? website}) async {
    bool updated = true;
    String? error;
    await userRef.doc(id).update({
      "website": website,
    }).catchError((e) {
      error = e.message;
    });
    if (error != null) {
      updated = false;
    }
    return updated;
  }

  Future<bool> updateLastSeenZipcode({String? id, String? zip}) async {
    await userRef.doc(id).update({
      "lastSeenZipcode": zip,
    }).catchError((e) {
      _snackbarService!.showSnackbar(
        title: 'Error',
        message: 'There was an issue updating your profile. Please try again.',
        duration: Duration(seconds: 3),
      );
      return false;
    });
    return true;
  }

  Future<bool> completeOnboarding({required String uid}) async {
    bool updated = true;
    await userRef.doc(uid).update({"onboarded": true}).catchError((e) {
      print(e.meesage);
    });
    return updated;
  }

  Future<bool> followUser(String currentUID, String targetUserID) async {
    String? error;
    await userRef.doc(currentUID).update({
      'following': FieldValue.arrayUnion([targetUserID])
    }).catchError((e) {
      error = e.message;
    });
    await userRef.doc(targetUserID).update({
      'followers': FieldValue.arrayUnion([currentUID])
    }).catchError((e) {
      error = e.message;
    });

    //follow posts by user
    QuerySnapshot postQuery = await postsRef.where('authorID', isEqualTo: targetUserID).get();
    postQuery.docs.forEach((doc) {
      postsRef.doc(doc.id).update({
        'followers': FieldValue.arrayUnion([currentUID])
      }).catchError((e) {
        error = e.message;
      });
    });

    if (error != null) {
      _customDialogService.showErrorDialog(description: "Unknown error. Please Try Again Later");
      return false;
    }

    return true;
  }

  Future<bool> unFollowUser(String currentUID, String targetUserID) async {
    String? error;
    await userRef.doc(currentUID).update({
      'following': FieldValue.arrayRemove([targetUserID])
    }).catchError((e) {
      error = e.message;
    });
    await userRef.doc(targetUserID).update({
      'followers': FieldValue.arrayRemove([currentUID])
    }).catchError((e) {
      error = e.message;
    });

    //unfollow posts by user
    QuerySnapshot postQuery = await postsRef.where('authorID', isEqualTo: targetUserID).get();
    postQuery.docs.forEach((doc) {
      postsRef.doc(doc.id).update({
        'followers': FieldValue.arrayRemove([currentUID])
      }).catchError((e) {
        error = e.message;
      });
    });

    if (error != null) {
      _customDialogService.showErrorDialog(description: "Unknown error. Please Try Again Later");
      return false;
    }

    return true;
  }

  Future<bool> depositWebblen({String? uid, required double amount}) async {
    //String error;
    DocumentSnapshot snapshot = await userRef.doc(uid).get();
    WebblenUser user = WebblenUser.fromMap(snapshot.data()!);
    double initialBalance = user.WBLN == null ? 0.00001 : user.WBLN!;
    double newBalance = amount + initialBalance;
    await userRef.doc(uid).update({"WBLN": newBalance}).catchError((e) {
      print(e.message);
      //error = e.toString();
    });
    return true;
  }

  Future<bool> withdrawWebblen({String? uid, required double amount}) async {
    //String error;

    DocumentSnapshot snapshot = await userRef.doc(uid).get();
    WebblenUser user = WebblenUser.fromMap(snapshot.data()!);
    double initialBalance = user.WBLN == null ? 0.00001 : user.WBLN!;
    double newBalance = initialBalance - amount;

    await userRef.doc(uid).update({"WBLN": newBalance}).catchError((e) {
      print(e.message);
      //error = e.toString();
    });
    return true;
  }

  ///QUERIES
  Future<List<DocumentSnapshot>> loadUserFollowers({required String? id, required int resultsLimit}) async {
    List<DocumentSnapshot> docs = [];
    Query query = userRef.where('following', arrayContains: id).orderBy('username', descending: false).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        _snackbarService!.showSnackbar(
          title: 'Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }

  Future<List<DocumentSnapshot>> loadAdditionalUserFollowers({
    required String? id,
    required DocumentSnapshot lastDocSnap,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = userRef.where('following', isEqualTo: id).orderBy('username', descending: false).startAfterDocument(lastDocSnap).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        _snackbarService!.showSnackbar(
          title: 'Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }

  Future<List<DocumentSnapshot>> loadUserFollowing({required String? id, required int resultsLimit}) async {
    List<DocumentSnapshot> docs = [];
    Query query = userRef.where('followers', arrayContains: id).orderBy('username', descending: false).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        _snackbarService!.showSnackbar(
          title: 'Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }

  Future<List<DocumentSnapshot>> loadAdditionalUserFollowing({
    required String? id,
    required DocumentSnapshot lastDocSnap,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query = userRef.where('followers', isEqualTo: id).orderBy('username', descending: false).startAfterDocument(lastDocSnap).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        _snackbarService!.showSnackbar(
          title: 'Error',
          message: e.message,
          duration: Duration(seconds: 5),
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }
}
