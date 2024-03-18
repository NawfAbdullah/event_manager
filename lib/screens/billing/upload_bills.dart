import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class UploadBills extends StatefulWidget {
  UploadBills(
      {super.key, required this.subEventModel, required this.eventModel});
  SubEventModel subEventModel;
  EventModel eventModel;

  @override
  State<UploadBills> createState() => _UploadBillsState();
}

class _UploadBillsState extends State<UploadBills> {
  File? _imgFile;
  String desc = '';
  void takeSnapshot() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.camera, // alternatively, use ImageSource.gallery
      maxWidth: 400,
    );
    if (img == null) return;
    setState(() {
      _imgFile = File(img.path); // convert it to a Dart:io file
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _imgFile != null
            ? Image.file(
                _imgFile!,
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200,
              )
            : Container(
                width: 100,
                height: 100,
                color: Colors.grey,
              ),
        TextField(
          decoration: kInputdecoration.copyWith(
              hintText: '', labelText: 'Bill description'),
          onChanged: (value) {
            setState(() {
              desc = value;
            });
          },
        ),
        GestureDetector(
          onTap: () => takeSnapshot(),
          child: Container(
            width: 150,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                Text(
                  'Take Picture',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        SubmitButton(
            onTap: () async {
              FlutterSecureStorage secureStorage = FlutterSecureStorage();
              final id = await secureStorage.read(key: 'sessionId');
              final bytes = File(_imgFile!.path).readAsBytesSync();
              String img64 = base64Encode(bytes);
              final response = await post(
                  Uri.parse(
                    "https://event-management-backend.up.railway.app/api/bill/upload-bill",
                  ),
                  body: jsonEncode({
                    "sub_event_id": widget.subEventModel.id,
                    "event_id": widget.eventModel.id,
                    "description": desc,
                    "img": "data:image/png;base64," + img64,
                  }),
                  headers: {
                    "content-type": 'application/json',
                    "session_token": id ?? '',
                  });
              if (response.statusCode == 200) {
                print(response.body);
              } else {
                print("Errrrrrrrrrrorrrrrrrr");
                print(response.body);
              }
            },
            innerText: 'Upload Bill')
      ],
    );
  }
}
