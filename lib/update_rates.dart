import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iotapp/homepage.dart';
import 'package:iotapp/main.dart';
import 'dart:convert';


class FuelUpdatePage extends StatefulWidget {
    final String username; // Username passed to the widget
    FuelUpdatePage({required this.username});


  @override
  _FuelUpdatePageState createState() => _FuelUpdatePageState();
}

class _FuelUpdatePageState extends State<FuelUpdatePage> {
  TextEditingController petrolController = TextEditingController();
  TextEditingController dieselController = TextEditingController();

  Future<void> updateRates(double petrolRate, double dieselRate) async {
          String username = widget.username; // Accessing username here
    final url = Uri.parse('http://10.0.2.2:8000/petrol/update-rates/');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'petrol_rate': petrolRate, 'diesel_rate': dieselRate}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully Updated Rates'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username: username,)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Update Rates'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel Update'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Update Fuel',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Icon(Icons.local_gas_station, size: 50),
                  SizedBox(height: 20),
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
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
        ],
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
