import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:open_trivia_king/states/user_state.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserState userState = Provider.of<UserState>(context, listen: true);

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 75,
            backgroundColor: Colors.grey,
            backgroundImage: (userState.profilePic == null
                ? Image.asset(
                    "assets/images/avatar.png",
                    fit: BoxFit.cover,
                  ).image
                : Image.file(userState.profilePic!).image),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: FloatingActionButton(
              heroTag: 'New Profile pic via Camera',
              child: const Icon(
                Icons.camera_alt,
              ),
              onPressed: () => changeProfilePic(userState, ImageSource.camera),
              mini: true,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'New Profile pic via Gallery',
              child: const Icon(
                Icons.photo,
              ),
              onPressed: () => changeProfilePic(userState, ImageSource.gallery),
              mini: true,
            ),
          ),
        ],
      ),
    );
  }

  // Handles taking a new photo for profile pic
  void changeProfilePic(UserState userState, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final ImageCropper cropper = ImageCropper();
    final XFile? photo = await picker.pickImage(source: source);
    if (photo == null) return;

    CroppedFile? croppedPhoto = await cropper.cropImage(
      sourcePath: photo.path,
      cropStyle: CropStyle.circle,
    );
    if (croppedPhoto == null) return;
    File image = File(croppedPhoto.path);

    String path = (await getApplicationDocumentsDirectory()).path;

    File savedImage =
        await image.copy('$path/profilepic_${croppedPhoto.hashCode}.png');
    userState.setProfilePic(savedImage);
  }
}
