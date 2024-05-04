import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DispensersPage extends StatefulWidget {
  @override
  _DispensersPageState createState() => _DispensersPageState();
}

class _DispensersPageState extends State<DispensersPage> {
  late List<dynamic> dispensers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/petrol/dispensers/'));

    if (response.statusCode == 200) {
      setState(() {
        dispensers = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispensers'),
      ),
      body: dispensers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dispensers.length,
              itemBuilder: (context, index) {
                final dispenser = dispensers[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DISPENSER ID: ${dispenser['dispenser_id']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text('Petrol Rate: ${dispenser['petrol_rate']}'),
                              Text('Diesel Rate: ${dispenser['diesel_rate']}'),
                              Text('Petrol Stock: ${dispenser['petrol_stock']}'),
                              Text('Diesel Stock: ${dispenser['diesel_stock']}'),
                              Row(
                                children: [
                                  Text('Dispensing Mode: '),
                                  dispenser['dispensing_mode']
                                      ? Icon(Icons.check, color: Colors.green) // Tick icon
                                      : Icon(Icons.close, color: Colors.red), // Cross icon
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/512/3448/3448636.png',
                          width: 50,
                          height: 50,
                          // Adjust width and height as per your requirement
                        ),
                      ],
                    ),
                  ),
                );
              },
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
        // currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        // onTap: _onItemTapped,
      ),
    );
  }
}