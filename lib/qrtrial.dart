import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iotapp/homepage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QRScanPage extends StatefulWidget {
    final String username;

  QRScanPage({required this.username});

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
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
          ElevatedButton(
            onPressed: () {
              _sendDataToAPI(qrText);
            },
            child: Text('Purchase'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
      });
    });
  }

  void _sendDataToAPI(String qrData) async 
  {
    String username = widget.username; // Accessing username here
    // Extracting data from QR code
    List<String> qrParts = qrData.split(':');
    String dispenserId = qrParts[1];
    String rupees = qrParts[3];

    // Making the POST request
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/petrol/purchase-fuel/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "username":username,
        'dispenser_id': dispenserId,
        'fuel_type': 'petrol',
        'litters': rupees,
      }),
    );

    // Handling the response
    if (response.statusCode == 201) 
    {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String message = responseData['message'];
          showDialog
          (
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Response'),
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
      Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage(username: username)),);
    } 
    else 
    {
            showDialog
            (
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to purchase fuel. Please try again.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
