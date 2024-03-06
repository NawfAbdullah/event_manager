import 'dart:io';
import 'package:event_manager/screens/scanner/results.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import '/results.dart';

class Scanner extends StatefulWidget {
  const Scanner({
    super.key,
  });

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();

    // To display the current output from the Camera,
    // create a CameraController.
  }

  @override
  void dispose() {
    // Dispose of the controller w
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller?.pauseCamera();
    }

    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [buildQrView(context)]);
  }

  Widget buildQrView(BuildContext context) => QRView(
      key: qrKey,
      overlay: QrScannerOverlayShape(
        borderRadius: 10,
        borderWidth: 20,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
      onQRViewCreated: (QRViewController con_troller) {
        setState(() {
          con_troller.scannedDataStream.listen((event) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultScreen(uuid: event.code)));
          });
        });
      });
}
