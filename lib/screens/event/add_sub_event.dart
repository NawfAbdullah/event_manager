import 'dart:convert';
import 'dart:io';
import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/EventModel.dart';
import 'package:event_manager/screens/event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class AddSubEvent extends StatefulWidget {
  const AddSubEvent({super.key, required this.event});
  final EventModel event;
  @override
  State<AddSubEvent> createState() => _AddSubEventState();
}

class _AddSubEventState extends State<AddSubEvent> {
  String subEventName = '';
  String desc = '';
  bool isLoading = false;
  String error = '';
  File? _imgFile;
  void getPicker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery, // alternatively, use ImageSource.gallery
      maxWidth: 400,
    );
    if (img == null) return;
    setState(() {
      _imgFile = File(img.path); // convert it to a Dart:io file
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff92a95f),
      body: Center(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () => getPicker(),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _imgFile != null
                                ? Image.file(
                                    _imgFile!,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
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
                    Container(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            subEventName = value;
                          });
                        },
                        decoration: kInputdecoration.copyWith(
                          hintText: '',
                          labelText: 'Sub Event Name',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            desc = value;
                          });
                        },
                        decoration: kInputdecoration.copyWith(
                          hintText: '',
                          labelText: 'Description',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SubmitButton(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        FlutterSecureStorage storage = FlutterSecureStorage();
                        final id = await storage.read(key: 'sessionId');
                        final bytes = File(_imgFile!.path).readAsBytesSync();
                        String img64 = base64Encode(bytes);
                        final response = await post(
                            Uri.parse(
                              'https://event-management-backend.up.railway.app/api/sub-event/create',
                            ),
                            body: jsonEncode({
                              'name': subEventName,
                              'event_id': widget.event.id,
                              "description": desc,
                              "img": "data:image/png;base64," + img64
                            }),
                            headers: {
                              'content-type': 'application/json',
                              'session_token': id ?? ''
                            });
                        setState(() {
                          isLoading = false;
                        });
                        if (response.statusCode == 200) {
                          print(response.body);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return Event(
                                eventModel: widget.event,
                                role: 'studentcoordinator',
                              );
                            },
                          ));
                        } else {
                          print(response.body);
                        }
                      },
                      innerText: 'Submit',
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
