import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';

class PostPicure extends StatelessWidget {
  const PostPicure({
    Key? key,
    required this.file,
  }) : super(key: key);

  final XFile? file;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.9,
        child: context.watch<DashboardProvider>().file != null
            ? Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: FileImage(
                    File(context.watch<DashboardProvider>().file!.path),
                  ),
                  fit: BoxFit.cover,
                )),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                  ),
                  child: Center(
                    child: TextButton(
                        onPressed: () async {
                          final ImagePicker imagePicker = ImagePicker();
                          final file = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 20);
                          if (file != null) {
                            context.read<DashboardProvider>().setPostImageFile(file);
                          }
                        },
                        child: const Text("Add Photo")),
                  ),
                ),
              ),
      ),
    );
  }
}
