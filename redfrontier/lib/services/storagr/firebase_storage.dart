import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redfrontier/common/dialogs.dart';
import 'package:redfrontier/main.dart';

class FirebaseStorageService {
  static Future<String?> uploadImage(File file) async {
    final Completer<String?> completer = Completer<String>();
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('report_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.whenComplete(() async {
        // Get the download URL after the image is uploaded
        String imageUrl = await storageRef.getDownloadURL();
        print('Image uploaded. URL: $imageUrl');
        completer.complete(imageUrl);
      });
    } catch (e) {
      print('Error uploading image: $e');
      return CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'ImageUploadError',
        contentText: 'unable to upload image',
      );
      completer.complete(null);
    }

    return completer.future;
  }
}
