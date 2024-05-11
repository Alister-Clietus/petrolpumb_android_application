import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  final void Function(String uniqueID, String amount) onScanCompleted;

  QRScannerScreen({required this.onScanCompleted});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String qrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scanned Data: $qrText'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
      });

      List<String> qrParts = qrText.split(';');
      String amount = qrParts.length >= 1 ? qrParts[0] : '';
      String uniqueID = qrParts.length >= 2 ? qrParts[1] : '';

      print('Unique ID: $uniqueID, Amount: $amount');

      // Pass the scanned data back to the caller
      widget.onScanCompleted(uniqueID, amount);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
