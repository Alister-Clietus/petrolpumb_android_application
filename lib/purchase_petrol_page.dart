

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iotapp/homepage.dart';
import 'package:iotapp/qrcode.dart';

class PurchasePetrolPage extends StatefulWidget {
  final String username; // Username passed to the widget
  PurchasePetrolPage({required this.username});

  @override
  _PurchasePetrolPageState createState() => _PurchasePetrolPageState();
}

class _PurchasePetrolPageState extends State<PurchasePetrolPage> {
  int _selectedIndex =
      0; // Index of the selected item in the bottom navigation bar
  int _dispenserId = 0;
  int _amount = 0;
  String _fuelType = 'diesel';

  void _onItemTapped(int index) {
    // Handle navigation to different pages based on the selected index
    // You can navigate to different pages or update the UI based on the index
    // For simplicity, I'm just updating the state to change the selected index
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> purchaseFuel(BuildContext context, int dispenserId,
      String fuelType, int liters) async {
     String username = widget.username;
          if (dispenserId != null && liters != null && dispenserId != 0) 
          {
              final url = Uri.parse('http://10.0.2.2:8000/petrol/purchase-fuel/');
              final Map<String, dynamic> requestBody = {
                'username': username,
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
              } else if (response.statusCode == 400) {
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
              } else {
                // Handle other HTTP errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to purchase fuel'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
          } 
          else
          {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Dipenser id and Liters are Empty'),
                backgroundColor: Colors.red,
              ),
            );
          }

    
  }

@override
Widget build(BuildContext context) {
      String username = widget.username; // Accessing username here
  return Scaffold(
    appBar: AppBar(
      title: Text('Purchase Fuel'),
    ),
    resizeToAvoidBottomInset: false, // Disable resizing when the keyboard appears
    body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.purple.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton
                      (
                        onPressed: () async 
                          {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QRScannerScreen
                                (
                                  onScanCompleted: (uniqueID, amount) 
                                  {
                                    _dispenserId = int.tryParse(uniqueID) ?? 0;
                                    _amount = int.tryParse(amount) ?? 0;
                                    _fuelType = "petrol";
                                    purchaseFuel(context, _dispenserId, _fuelType, _amount);
                                    print('Unique ID: $uniqueID, Amount: $amount');
                                  }, username: username, //onScanCompleted
                                ),
                              ),
                            );
                          }, //Onpressed
                        child: Text('Scan QR Code'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05), // Adjust spacing according to screen height
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.purple.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _dispenserId = int.tryParse(value) ?? 0;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter Dispenser ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.confirmation_number),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (value1) {
                        setState(() {
                          _amount = int.tryParse(value1) ?? 0;
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.confirmation_number),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _fuelType = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Fuel Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.local_gas_station),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          purchaseFuel(context, _dispenserId, _fuelType, _amount);
                        },
                        icon: Icon(Icons.local_gas_station),
                        label: Text('Purchase Diesel'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    ),
  );
}

}

