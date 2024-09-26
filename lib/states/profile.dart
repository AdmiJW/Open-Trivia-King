import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:io';

final profileBoxProvider = FutureProvider<Box>((ref) async => Hive.openBox('profile'));

class ProfileState {
  final String username;
  final File? profilePic;

  ProfileState({this.username = "Anonymous", this.profilePic});

  ProfileState copyWith({
    String? username,
    File? profilePic,
  }) {
    return ProfileState(
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  Future<Box> get _box async => ref.watch(profileBoxProvider.future);

  @override
  ProfileState build() {
    state = ProfileState();
    _loadFromPersistentStorage();
    return state;
  }

  Future<void> reset() async {
    if (state.profilePic != null && state.profilePic!.existsSync()) {
      await state.profilePic!.delete();
    }
    state = ProfileState();
    await _saveToPersistentStorage();
  }

  Future<void> setUsername(String username) async {
    state = state.copyWith(username: username);
    await _saveToPersistentStorage();
  }

  Future<void> setProfilePic(File image) async {
    if (!image.existsSync()) {
      throw ArgumentError("Invalid non-existent profile picture provided at ${image.path}");
    }
    // Delete the old profile pic before setting to a new profile picture
    if (state.profilePic != null && state.profilePic!.existsSync() && state.profilePic!.path != image.path) {
      state.profilePic!.deleteSync();
    }

    state = state.copyWith(profilePic: image);
    await _saveToPersistentStorage();
  }

  Future<void> _saveToPersistentStorage() async {
    final box = await _box;
    await box.put('username', state.username);
    await box.put('profilePicPath', state.profilePic?.path);
  }

  Future<void> _loadFromPersistentStorage() async {
    final box = await _box;
    state = state.copyWith(
      username: box.get('username'),
      profilePic: box.get('profilePicPath') != null ? File(box.get('profilePicPath')) : null,
    );
  }
}

final profileStateProvider = NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
