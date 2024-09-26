import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:open_trivia_king/states/profile.dart';

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Stack(
        children: [
          const Avatar(),
          Positioned(
            bottom: 0,
            left: 0,
            child: FloatingActionButton(
              heroTag: 'New Profile pic via Camera',
              onPressed: () => changeProfilePic(ref, ImageSource.camera),
              mini: true,
              child: const Icon(
                Icons.camera_alt,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'New Profile pic via Gallery',
              onPressed: () => changeProfilePic(ref, ImageSource.gallery),
              mini: true,
              child: const Icon(
                Icons.photo,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handles taking a new photo for profile pic
  void changeProfilePic(WidgetRef ref, ImageSource source) async {
    final profileNotifier = ref.read(profileStateProvider.notifier);

    final ImagePicker picker = ImagePicker();
    final ImageCropper cropper = ImageCropper();
    final XFile? photo = await picker.pickImage(source: source);
    if (photo == null) return;

    CroppedFile? croppedPhoto = await cropper.cropImage(sourcePath: photo.path, uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Avatar',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        cropStyle: CropStyle.circle,
      ),
    ]);
    if (croppedPhoto == null) return;
    File image = File(croppedPhoto.path);

    String path = (await getApplicationDocumentsDirectory()).path;

    File savedImage = await image.copy('$path/profilepic_${croppedPhoto.hashCode}.png');
    await profileNotifier.setProfilePic(savedImage);
  }
}

class Avatar extends ConsumerWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileStateProvider);

    return CircleAvatar(
      radius: 75,
      backgroundColor: Colors.grey,
      backgroundImage: (profile.profilePic == null
          ? Image.asset(
              "assets/images/avatar.png",
              fit: BoxFit.cover,
            ).image
          : Image.file(profile.profilePic!).image),
    );
  }
}
