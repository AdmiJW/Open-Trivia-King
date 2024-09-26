import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  loggedOut,
  loggedIn,
}

class AuthState {
  final AuthStatus status;
  final String? uid;
  final String? displayName;
  final String? email;
  final String? profilePicUrl;
  final String? googleStorageProfilePicPath;

  AuthState({
    this.status = AuthStatus.loggedOut,
    this.uid,
    this.displayName,
    this.email,
    this.profilePicUrl,
    this.googleStorageProfilePicPath,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? uid,
    String? displayName,
    String? email,
    String? profilePicUrl,
    String? googleStorageProfilePicPath,
  }) {
    return AuthState(
      status: status ?? this.status,
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      googleStorageProfilePicPath: googleStorageProfilePicPath ?? this.googleStorageProfilePicPath,
    );
  }
}

class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    state = AuthState();
    _listenToUserChanges();
    return state;
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async => FirebaseAuth.instance.signOut();

  void _listenToUserChanges() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        state = AuthState();
        return;
      }

      state = AuthState(
        status: AuthStatus.loggedIn,
        displayName: user.displayName ?? user.providerData[0].displayName,
        email: user.email ?? user.providerData[0].email,
        profilePicUrl: user.photoURL ?? user.providerData[0].photoURL,
        uid: user.uid,
      );
    });
  }

  void setGoogleStorageProfilePicPath(String path) {
    state = state.copyWith(googleStorageProfilePicPath: path);
  }
}

final authStateProvider = NotifierProvider<AuthStateNotifier, AuthState>(AuthStateNotifier.new);
