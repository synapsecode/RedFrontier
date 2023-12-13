import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redfrontier/common/dialogs.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/models/reports.dart';
import 'package:redfrontier/services/firestore/reports.dart';
import 'package:redfrontier/services/storagr/firebase_storage.dart';

class AddReportDialog extends StatefulWidget {
  const AddReportDialog({super.key});

  @override
  State<AddReportDialog> createState() => _AddReportDialogState();
}

class _AddReportDialogState extends State<AddReportDialog> {
  File? _image;
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _submitReport() async {
    String? imgURL;
    if (_image != null) {
      imgURL = await FirebaseStorageService.uploadImage(_image!);
      if (imgURL == null) {
        // return CustomDialogs.showDefaultAlertDialog(
        //   context,
        //   contentTitle: 'ImageUploadError',
        //   contentText: 'unable to upload image',
        // );
      }
      final creator = gpc.read(currentRFUserProvider);
      final report = Report.fromMap({
        'media_url': imgURL ?? 'none',
        'title': titleC.value.text,
        'description': descC.value.text,
        'creator_uid': creator!.id,
      });
      await FirestoreReportService.createReport(report);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
          title: Text('Enter Information',
              style: Theme.of(context).textTheme.displayLarge),
          content: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text('Add Image:'),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: _getImage,
                child: _image != null
                    ? Image.file(
                        _image!,
                        width: 200,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 200,
                        height: 100,
                        color: Colors.black,
                        child: const Icon(Icons.camera_enhance_rounded,
                            color: Colors.white),
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                controller: titleC,
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                controller: descC,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _submitReport,
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ]),
    );
  }
}
