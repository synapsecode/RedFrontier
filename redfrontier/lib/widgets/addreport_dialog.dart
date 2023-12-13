import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddReportDialog extends StatefulWidget {
  const AddReportDialog({super.key});

  @override
  State<AddReportDialog> createState() => _AddReportDialogState();
}

class _AddReportDialogState extends State<AddReportDialog> {
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ]),
    );
  }
}
