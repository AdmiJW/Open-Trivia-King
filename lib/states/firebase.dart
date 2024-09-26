import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_trivia_king/states/profile.dart';
import 'package:open_trivia_king/states/stats.dart';
import 'package:open_trivia_king/states/auth.dart';

class FirebaseNotifier extends Notifier<void> {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  @override
  void build() {}

  Future<void> saveToFirestore() {
    final auth = ref.read(authStateProvider);
    final profile = ref.read(profileStateProvider);
    final stats = ref.read(statsStateProvider);

    return _users
        .doc(auth.uid)
        .set({
          'username': profile.username,
          'totalQuestionsAnswered': stats.totalQuestionsAnswered,
          'totalQuestionsAnsweredCorrectly': stats.totalQuestionsAnsweredCorrectly,
          'highestStreak': stats.highestStreak,
          'categoriesAnswered': stats.categoriesAnswered,
          'categoriesAnsweredCorrectly': stats.categoriesAnsweredCorrectly,
          'googleStorageProfilePicPath': auth.googleStorageProfilePicPath,
        })
        .then((_) => Fluttertoast.showToast(msg: "User data successfully saved to cloud!"))
        .catchError((error) {
          Fluttertoast.showToast(msg: "Data saving failed. Error: $error");
          return null;
        });
  }

  Future<void> loadFromFirestore() {
    final auth = ref.read(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);
    final profileNotifier = ref.read(profileStateProvider.notifier);
    final statsNotifier = ref.read(statsStateProvider.notifier);

    Fluttertoast.showToast(
      msg: "Fetching user data... Please wait",
    );

    return _users.doc(auth.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        throw ArgumentError("User data is non-existent in the database! Have you saved before?");
      }

      dynamic data = documentSnapshot.data();
      Map<String, int> categoriesAnswered = {};
      Map<String, int> categoriesAnsweredCorrectly = {};
      for (var entry in data['categoriesAnswered'].entries) {
        categoriesAnswered[entry.key] = entry.value;
      }
      for (var entry in data['categoriesAnsweredCorrectly'].entries) {
        categoriesAnsweredCorrectly[entry.key] = entry.value;
      }

      authNotifier.setGoogleStorageProfilePicPath(data['googleStorageProfilePicPath']);
      profileNotifier.setUsername(data['username']);
      statsNotifier.set(
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

  Future<void> saveProfilePicToStorage() async {
    final auth = ref.read(authStateProvider);
    final profile = ref.read(profileStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);
    final profileNotifier = ref.read(profileStateProvider.notifier);

    if (profile.profilePic == null) return;

    // Force renaming of the local profile pic to be `uid.ext`
    File profilePic = profile.profilePic!;
    String uid = auth.uid!;
    String oripath = profilePic.absolute.path;
    String dir = path.dirname(oripath);
    String ext = path.extension(oripath);
    String renamedName = path.join(dir, '$uid$ext');

    if (profile.profilePic!.path != renamedName) {
      profilePic = profilePic.copySync(renamedName);
      profileNotifier.setProfilePic(profilePic);
    }

    try {
      final storageRef = 'profilepic/$uid$ext';
      await FirebaseStorage.instance.ref(storageRef).putFile(profilePic);
      authNotifier.setGoogleStorageProfilePicPath(storageRef);
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: "Error while uploading profile picture! Error: $e");
    }
  }

  Future<void> loadProfilePicFromStorage() async {
    final auth = ref.read(authStateProvider);
    final userNotifier = ref.read(profileStateProvider.notifier);

    if (auth.googleStorageProfilePicPath == null) return;

    String basename = path.basename(auth.googleStorageProfilePicPath as String);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String downloadPath = '${appDocDir.path}/$basename';
    // String downloadPath = '${appDocDir.path.replaceFirst("/data/user/0", "/data/data")}/$basename';
    File downloadToFile = File(downloadPath);

    try {
      await FirebaseStorage.instance.ref(auth.googleStorageProfilePicPath).writeToFile(downloadToFile);
      userNotifier.setProfilePic(downloadToFile);
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') {
        Fluttertoast.showToast(msg: "Error while attempting to retrieve profile picture! Error: $e");
        return;
      }
      rethrow;
    }
  }
}

final firebaseProvider = NotifierProvider<FirebaseNotifier, void>(FirebaseNotifier.new);
