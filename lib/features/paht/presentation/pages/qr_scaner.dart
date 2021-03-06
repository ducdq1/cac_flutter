import 'dart:io';

import 'package:citizen_app/features/common/widgets/layouts/base_layout_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';

class QRSCaner extends StatefulWidget {
  @override
  _QRSCanerState createState() => _QRSCanerState();
}

class _QRSCanerState extends State<QRSCaner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String result;
  QRViewController controller;
  bool isScanned = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutWidget(
      title: 'Quét mã QR',
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                overlayColor: Colors.transparent.withOpacity(0.7),
                borderWidth: 8,
                cutOutSize: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      try {
        if (!isScanned) {
          isScanned = true;

          result = scanData;
          controller.pauseCamera();
          final hasVibrator = await Vibration.hasVibrator();
          if (hasVibrator) {
            Vibration.vibrate(duration: 100, amplitude: 1);
          }

          Future.delayed(Duration(milliseconds: 1000), () {
            Navigator.of(context).pop(result);
          });

        }
      } catch (e) {

      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
