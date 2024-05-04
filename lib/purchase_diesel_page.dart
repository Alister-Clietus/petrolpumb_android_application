import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PurchaseDieselPage extends StatefulWidget {
  @override
  _PurchaseDieselPageState createState() => _PurchaseDieselPageState();
}

class _PurchaseDieselPageState extends State<PurchaseDieselPage> {
  int _selectedIndex = 0; // Index of the selected item in the bottom navigation bar
  int _dispenserId = 0;

  void _onItemTapped(int index) {
    // Handle navigation to different pages based on the selected index
    // You can navigate to different pages or update the UI based on the index
    // For simplicity, I'm just updating the state to change the selected index
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> enableDispenser(BuildContext context, int dispenserId) async {
    final url = Uri.parse('http://10.0.2.2:8000/petrol/dispenser/$dispenserId/enable/');
    final response = await http.put(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'Dispenser mode enabled successfully') {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dispenser mode enabled successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      // Handle HTTP error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to enable dispenser mode'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Diesel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan QR Code to Purchase Diesel',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement QR code scanning functionality
              },
              child: Text('Scan QR Code'),
            ),
            SizedBox(height: 20),
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
                fillColor: Colors.purple.withOpacity(0.1),
                prefixIcon: Icon(Icons.confirmation_number),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _dispenserId == 0
                  ? null
                  : () {
                      enableDispenser(context, _dispenserId);
                    },
              child: Text('Enable'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
          ],
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
