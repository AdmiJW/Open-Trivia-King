import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_trivia_king/states/auth_state.dart';
import 'package:open_trivia_king/states/user_state.dart';

//?================================================================================================
//? This dart file contain methods to save userData to and from the firestore and profile pic to
//? and from the storage bucket, provided the userState, authState
//?================================================================================================
//?
//? Planned Workflow:
//?
//?			User initiates Saving
//?					↓
//?			Profile pic upload, recorded firebase storage path to profile pic
//?					↓
//?			Save user data, with firebase storage path to profile pic
//?					↓
//?					↓
//?			User initiates Loading
//?					↓
//?			User data loaded, along with recorded firebase storage path to profile pic
//?					↓
//?			Profile pic loaded using recorded firebase storage path
//?
//?
//? The firebase storage path is recorded in authState.

CollectionReference _users = FirebaseFirestore.instance.collection('users');

Future<void> saveUserStateToFirestore(
    AuthState authState, UserState userState) {
  return _users
      .doc(authState.uid)
      .set({
        'username': userState.username,
        'totalQuestionsAnswered': userState.totalQuestionsAnswered,
        'totalQuestionsAnsweredCorrectly':
            userState.totalQuestionsAnsweredCorrectly,
        'highestStreak': userState.highestStreak,
        'categoriesAnswered': userState.categoriesAnswered,
        'categoriesAnsweredCorrectly': userState.categoriesAnsweredCorrectly,
        'googleStorageProfilePicPath': authState.googleStorageProfilePicPath,
      })
      .then((_) =>
          Fluttertoast.showToast(msg: "User data successfully saved to cloud!"))
      .catchError((error) {
        Fluttertoast.showToast(msg: "Data saving failed. Error: $error");
        return null;
      });
}

Future<void> loadUserStateFromFirestore(
    AuthState authState, UserState userState) {
  Fluttertoast.showToast(
    msg: "Fetching user data... Please wait",
  );

  return _users
      .doc(authState.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (!documentSnapshot.exists) {
      throw ArgumentError(
          "User data is non-existent in the database! Have you saved before?");
    }

    dynamic data = documentSnapshot.data();

    // Map<String, dynamic> has to be converted to Map<string, int>
    Map<String, int> categoriesAnswered = {};
    Map<String, int> categoriesAnsweredCorrectly = {};
    for (var entry in data['categoriesAnswered'].entries) {
      categoriesAnswered[entry.key] = entry.value;
    }
    for (var entry in data['categoriesAnsweredCorrectly'].entries) {
      categoriesAnsweredCorrectly[entry.key] = entry.value;
    }

    authState.googleStorageProfilePicPath = data['googleStorageProfilePicPath'];

    userState.setUserState(
      username: data['username'],
      totalQuestionsAnswered: data['totalQuestionsAnswered'],
      totalQuestionsAnsweredCorrectly: data['totalQuestionsAnsweredCorrectly'],
      highestStreak: data['highestStreak'],
      categoriesAnswered: categoriesAnswered,
      categoriesAnsweredCorrectly: categoriesAnsweredCorrectly,
    );

    Fluttertoast.showToast(msg: "User data successfully loaded.");
  }).catchError((error) {
    Fluttertoast.showToast(msg: "User data fetch failed. Error: $error");
  });
}

Future<void> saveProfilePicToStorage(
    AuthState authState, UserState userState) async {
  // if profile pic is null, try to check if any previous profile pic is at the storage. If yes, delete it/
  if (userState.profilePic == null) return;

  // Force renaming of the local profile pic to be {uid}.ext
  String oripath = userState.profilePic!.path;
  String dir = path.dirname(oripath);
  String ext = path.extension(oripath);
  String renamedName = path.join(dir, '${authState.uid}$ext');

  //! Somehow, /data/user/0 won't even work, but if i replace to /data/data, it works fine
  renamedName = renamedName.replaceFirst("/data/user/0", "/data/data");

  if (userState.profilePic!.path != renamedName) {
    File renamedProfilePicFile = userState.profilePic!.copySync(renamedName);
    userState.setProfilePic(renamedProfilePicFile);
  }

  try {
    await FirebaseStorage.instance
        .ref('profilepic/${authState.uid}$ext')
        .putFile(userState.profilePic as File);

    authState.googleStorageProfilePicPath = 'profilepic/${authState.uid}$ext';
  } on FirebaseException catch (e) {
    Fluttertoast.showToast(
        msg: "Error while uploading profile picture! Error: $e");
  }
}

Future<void> loadProfilePicFromStorage(
    AuthState authState, UserState userState) async {
  if (authState.googleStorageProfilePicPath == null) return;

  String basename =
      path.basename(authState.googleStorageProfilePicPath as String);
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String downloadPath =
      '${appDocDir.path.replaceFirst("/data/user/0", "/data/data")}/$basename';
  File downloadToFile = File(downloadPath);

  try {
    await FirebaseStorage.instance
        .ref(authState.googleStorageProfilePicPath)
        .writeToFile(downloadToFile);

    userState.setProfilePic(downloadToFile);
  } on FirebaseException catch (e) {
    if (e.code != 'object-not-found') {
      Fluttertoast.showToast(
          msg: "Error while attempting to retrieve profile picture! Error: $e");
    }
  }
}
