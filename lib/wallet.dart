import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iotapp/homepage.dart';
import 'dart:convert';

import 'package:iotapp/main.dart';

class WalletPage extends StatefulWidget {
  final String username; // Username passed to the widget
// Constructor with username parameter
  WalletPage({required this.username});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  int _selectedIndex =
      2; // Index of the selected item in the bottom navigation bar

  void _onItemTapped(int index) {
    // Handle navigation to different pages based on the selected index
    // You can navigate to different pages or update the UI based on the index
    // For simplicity, I'm just updating the state to change the selected index
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _updateWallet(String email, double amount) async {
      String username = widget.username; // Accessing username here
    final url = Uri.parse('http://10.0.2.2:8000/auth/update-wallet/');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'wallet_amount': amount}),
    );

    if (response.statusCode == 200) {
      // Handle success
      // final jsonResponse = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Money Added To Wallet'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username: username)),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recharge Wallet'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20), // Add margin
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet, // Wallet icon
                    color: Colors.black,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add Money to Wallet',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Amount',
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            String email = _emailController.text;
                            double amount =
                                double.tryParse(_amountController.text) ?? 0.0;
                            _updateWallet(email, amount); // Update wallet
                          },
                          child: Text('Add Money'),
                        ),
                      ],
                    ),
                  ),
                ],
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

  @override
  void dispose() {
    _emailController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}


