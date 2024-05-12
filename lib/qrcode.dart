import 'package:flutter/material.dart';
import 'package:iotapp/homepage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QRScannerScreen extends StatefulWidget {
  final void Function(String uniqueID, String amount) onScanCompleted;
    final String username; // Username passed to the widget
QRScannerScreen({required this.onScanCompleted, required this.username});

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
  controller.scannedDataStream.listen((scanData) async {
    setState(() {
      qrText = scanData.code!;
    });

    List<String> qrParts = qrText.split(';');
    String amount = qrParts.length >= 1 ? qrParts[0] : '';
    String uniqueID = qrParts.length >= 2 ? qrParts[1] : '';

    print('Unique ID: $uniqueID, Amount: $amount');

    // Pass the scanned data back to the caller
    widget.onScanCompleted(uniqueID, amount);

    // Call the API with scanned data
    await purchaseFuel(int.parse(uniqueID), 'petrol', int.parse(amount));
  });
}
      Future<void> purchaseFuel(int dispenserId, String fuelType, int liters) async {
      String username = widget.username; // Accessing username here
    if (dispenserId != null && liters != null && dispenserId != 0) {
    final url = Uri.parse('http://127.0.0.1:8000/petrol/purchase-fuel/');
    final Map<String, dynamic> requestBody = {
      'username':username,
      'dispenser_id': dispenserId,
      'fuel_type': fuelType,
      'litters': liters,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) 
    {
                final jsonResponse = json.decode(response.body);
                if (jsonResponse['message'] == 'FuelPurchased') {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fuel purchased successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(username: username)),
                );
                }
    } else {
      final jsonResponse = json.decode(response.body);
                if (jsonResponse.containsKey('error')) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(jsonResponse['error']),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Dipenser id and Liters are Empty'),
                backgroundColor: Colors.red,
              ),
            );
  }
}


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
