import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FuelUpdatePage extends StatefulWidget {
  @override
  _FuelUpdatePageState createState() => _FuelUpdatePageState();
}

class _FuelUpdatePageState extends State<FuelUpdatePage> {
  TextEditingController petrolController = TextEditingController();
  TextEditingController dieselController = TextEditingController();

  Future<void> updateRates(double petrolRate, double dieselRate) async {
    final url = Uri.parse('http://127.0.0.1:8000/petrol/update-rates/');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'petrol_rate': petrolRate, 'diesel_rate': dieselRate}),
    );

    if (response.statusCode == 200) {
      // Handle success
ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Successfull'),
                              ),
                            );    } else {
      // Handle error
ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed'),
                              ),
                            );    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel Update'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: petrolController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Update Petrol',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: dieselController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Update Diesel',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double petrolRate = double.parse(petrolController.text);
                double dieselRate = double.parse(dieselController.text);
                updateRates(petrolRate, dieselRate);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FuelUpdatePage(),
  ));
}
