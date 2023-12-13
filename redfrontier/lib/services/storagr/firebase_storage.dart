import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  static Future<String?> uploadImage(File file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('report_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.whenComplete(() async {
        // Get the download URL after the image is uploaded
        String imageUrl = await storageRef.getDownloadURL();
        print('Image uploaded. URL: $imageUrl');
        return imageUrl;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
