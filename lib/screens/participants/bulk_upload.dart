// import 'dart:convert';
// import 'dart:html';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// class BulkUpload extends StatefulWidget {
//   const BulkUpload({super.key});

//   @override
//   State<BulkUpload> createState() => _BulkUploadState();
// }

// class _BulkUploadState extends State<BulkUpload> {
//   late Uint8List csvFile;

//   _startFilePicker() async {
//     FileUploadInputElement uploadInput = FileUploadInputElement();
//     uploadInput.click();

//     uploadInput.onChange.listen((e) {
//       // read file content as dataURL
//       final files = uploadInput.files;
//       if (files!.length == 1) {
//         final file = files[0];
//         FileReader reader = FileReader();

//         reader.onLoadEnd.listen((e) {
//           setState(() {
//             csvFile = Base64Decoder()
//                 .convert(reader.result.toString().split(",").last);
//           });
//         });

//         reader.onError.listen((fileEvent) {});

//         reader.readAsDataUrl(file);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           _startFilePicker();
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             vertical: 10,
//             horizontal: 5,
//           ),
//           color: const Color.fromARGB(255, 176, 64, 251),
//           child: const Row(children: [
//             Icon(Icons.upload_file),
//             Text('Upload'),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// Uint8List uploadedCsv;
// String option1Text;

// _startFilePicker() async {
//   InputElement uploadInput = FileUploadInputElement();
//   uploadInput.click();

//   uploadInput.onChange.listen((e) {
//     // read file content as dataURL
//     final files = uploadInput.files;
//     if (files.length == 1) {
//       final file = files[0];
//       FileReader reader = FileReader();

//       reader.onLoadEnd.listen((e) {
//         setState(() {
//           uploadedCsv =
//               Base64Decoder().convert(reader.result.toString().split(",").last);
//         });
//       });

//       reader.onError.listen((fileEvent) {
//         setState(() {
//           option1Text = "Some Error occured while reading the file";
//         });
//       });

//       reader.readAsDataUrl(file);
//     }
//   });
// }
