import 'dart:convert';
import 'dart:io';
import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class UploadBills extends StatefulWidget {
  const UploadBills(
      {super.key, required this.subEventModel, required this.eventModel});
  final SubEventModel subEventModel;
  final EventModel eventModel;

  @override
  State<UploadBills> createState() => _UploadBillsState();
}

class _UploadBillsState extends State<UploadBills> {
  File? _imgFile;
  String desc = '';
  String error = '';
  String amount = '';
  bool isLoading = false;
  bool isSuccess = false;
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
    return isSuccess
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/lightning.png',
                    width: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Bill Uploaded",
                    style: TextStyle(fontSize: 20),
                  ),
                  SubmitButton(
                      onTap: () {
                        setState(() {
                          isSuccess = false;
                        });
                      },
                      innerText: 'Add another')
                ]),
          )
        : Container(
            color: const Color(0xff92a95f),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => takeSnapshot(),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _imgFile != null
                                      ? Image.file(
                                          _imgFile!,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          height: 200,
                                          color: const Color.fromARGB(
                                              255, 189, 255, 198),
                                          child: Center(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/photo.png',
                                                width: 100,
                                              ),
                                              const Text(
                                                'Upload',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )),
                                        )
                                ]),
                          ),
                          TextField(
                            decoration: kInputdecoration.copyWith(
                                hintText: '', labelText: 'Amount'),
                            onChanged: (value) {
                              setState(() {
                                amount = value;
                              });
                            },
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
                          SubmitButton(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                FlutterSecureStorage secureStorage =
                                    FlutterSecureStorage();
                                final id =
                                    await secureStorage.read(key: 'sessionId');
                                final bytes =
                                    File(_imgFile!.path).readAsBytesSync();
                                String img64 = base64Encode(bytes);
                                final response = await post(
                                    Uri.parse(
                                      "https://event-management-backend.up.railway.app/api/bill/upload-bill",
                                    ),
                                    body: jsonEncode({
                                      "sub_event_id": widget.subEventModel.id,
                                      "event_id": widget.eventModel.id,
                                      "description": desc,
                                      "amount": int.parse(amount),
                                      "img": "data:image/png;base64," + img64,
                                    }),
                                    headers: {
                                      "content-type": 'application/json',
                                      "session_token": id ?? '',
                                    });
                                if (response.statusCode == 200) {
                                  print(response.body);
                                  setState(() {
                                    error = '';
                                    isLoading = false;
                                    isSuccess = true;
                                  });
                                } else {
                                  setState(() {
                                    isLoading = false;
                                    error =
                                        jsonDecode(response.body)['err_msg'];
                                  });
                                  print(response.body);
                                }
                              },
                              innerText: 'Upload Bill')
                        ],
                      ),
                    ),
                  ),
          );
  }
}
//<a href="https://www.flaticon.com/free-icons/upload" title="upload icons">Upload icons created by Good Ware - Flaticon</a>