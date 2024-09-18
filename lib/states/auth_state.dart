// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStateEnum {
  loggedOut,
  loggedIn,
}

class AuthState extends ChangeNotifier {
  AuthStateEnum authState = AuthStateEnum.loggedOut;
  String? uid;
  String? displayName;
  String? email;
  String? profilePicUrl;

  String? googleStorageProfilePicPath;

  AuthState() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        authState = AuthStateEnum.loggedOut;
        displayName = email = profilePicUrl = uid = null;
      } else {
        authState = AuthStateEnum.loggedIn;
        displayName = user.displayName ?? user.providerData[0].displayName;
        email = user.email ?? user.providerData[0].email;
        profilePicUrl = user.photoURL ?? user.providerData[0].photoURL;
        uid = user.uid;
      }

      notifyListeners();
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
