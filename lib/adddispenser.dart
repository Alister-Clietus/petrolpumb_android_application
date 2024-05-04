import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PetrolDispenserPage extends StatefulWidget {
  @override
  _PetrolDispenserPageState createState() => _PetrolDispenserPageState();
}

class _PetrolDispenserPageState extends State<PetrolDispenserPage> {
  TextEditingController dispenserIdController = TextEditingController();
  TextEditingController petrolRateController = TextEditingController();
  TextEditingController dieselRateController = TextEditingController();
  TextEditingController petrolStockController = TextEditingController();
  TextEditingController dieselStockController = TextEditingController();
  bool dispensingMode = true;

  Future<void> sendData() async {
    final url = Uri.parse('http://10.0.2.2:8000/petrol/dispenser/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "dispenser_id": int.tryParse(dispenserIdController.text) ?? 0,
        "petrol_rate": double.tryParse(petrolRateController.text) ?? 0.0,
        "diesel_rate": double.tryParse(dieselRateController.text) ?? 0.0,
        "petrol_stock": int.tryParse(petrolStockController.text) ?? 0,
        "diesel_stock": int.tryParse(dieselStockController.text) ?? 0,
        "dispensing_mode": dispensingMode,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unsuccessful')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dispenser'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.local_gas_station,
                  size: 50.0,
                  color: Colors.blue,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Add Dispenser',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: dispenserIdController,
                  decoration: InputDecoration(labelText: 'Dispenser ID'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: petrolRateController,
                  decoration: InputDecoration(labelText: 'Petrol Rate'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: dieselRateController,
                  decoration: InputDecoration(labelText: 'Diesel Rate'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: petrolStockController,
                  decoration: InputDecoration(labelText: 'Petrol Stock'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: dieselStockController,
                  decoration: InputDecoration(labelText: 'Diesel Stock'),
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  title: Text('Dispensing Mode'),
                  value: dispensingMode,
                  onChanged: (bool value) {
                    setState(() {
                      dispensingMode = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    sendData();
                  },
                  child: Text('Add Dispenser'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PetrolDispenserPage(),
  ));
}
