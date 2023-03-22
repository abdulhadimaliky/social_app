import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/providers/auth_provider.dart';

class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({
    Key? key,
    required this.file,
  }) : super(key: key);

  final XFile? file;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.3,
            child: context.watch<AuthProvider>().file != null
                ? Container(
                    child: Image(
                      image: FileImage(File(context.watch<AuthProvider>().file!.path)),
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    color: Colors.amber,
                  ),
          ),
        ),
        Positioned(
            bottom: -5,
            right: -5,
            child: GestureDetector(
              onTap: () async {
                final ImagePicker imagePicker = ImagePicker();
                final file = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 20);
                if (file != null) {
                  context.read<AuthProvider>().setUserImageFile(file);
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Image.asset("assets/camera.png"),
              ),
            ))
      ],
    );
  }
}
