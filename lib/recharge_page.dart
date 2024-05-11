import 'package:flutter/material.dart';

class RechargePage extends StatefulWidget {
  final String username; // Username passed to the widget

  RechargePage({required this.username});

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State
{
  double _walletBalance = 0.0;
  TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0; // Index of the selected item in the bottom navigation bar

  void _onItemTapped(int index) {
    // Handle navigation to different pages based on the selected index
    // You can navigate to different pages or update the UI based on the index
    // For simplicity, I'm just updating the state to change the selected index
    _selectedIndex = index;
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
                // color: Colors.black, // Set background color to black
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
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter Amount',
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            double amount = double.tryParse(_controller.text) ?? 0.0;
                            _addMoney(amount); // Add amount entered in text field
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

  void _addMoney(double amount) {
    setState(() {
      _walletBalance += amount;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
