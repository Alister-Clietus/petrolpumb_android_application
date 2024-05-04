import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iotapp/adddispenser.dart';
import 'package:iotapp/dispenser.dart';
import 'package:iotapp/map.dart';
import 'package:iotapp/purchase_diesel_page.dart';
import 'package:iotapp/purchase_petrol_page.dart';
import 'package:iotapp/update_rates.dart';
import 'dart:convert';

import 'package:iotapp/wallet.dart';

class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username});

  Future<Map<String, dynamic>> fetchUserData(String username) async {
    final userDataResponse =
        await http.get(Uri.parse('http://10.0.2.2:8000/auth/user/$username/'));
    final ratesResponse =
        await http.get(Uri.parse('http://10.0.2.2:8000/petrol/rate/'));

    if (userDataResponse.statusCode == 200 && ratesResponse.statusCode == 200) {
      final userData = json.decode(userDataResponse.body);
      final ratesData = json.decode(ratesResponse.body);

      userData['petrol_rate'] = ratesData['petrol_rate'];
      userData['diesel_rate'] = ratesData['diesel_rate'];

      return userData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create an instance of the User class

    // Set the username using the setter method
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchUserData(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // or any loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Welcome, ${userData['username']}'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profile Details:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Name: ${userData['username']}'),
                              Text('Email: ${userData['email']}'),
                              Text(
                                  'Total Petrol Bought: ${userData['petrol_purchased']} liters'),
                              Text(
                                  'Total Diesel Bought: ${userData['diesel_purchased']} liters'),
                              Text(
                                  'Wallet Balance: \$ ${userData['wallet_amount']}'),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://banner2.cleanpng.com/20180329/zue/kisspng-computer-icons-user-profile-person-5abd85306ff7f7.0592226715223698404586.jpg'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: ElevatedButton(
        onPressed: () {
          launchMap(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: Text('Locate'),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WalletPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: const Text('Recharge'),
      ),
    ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DispensersPage()),
          );
        },
                style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: Text('Show Dispensers'),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PetrolDispenserPage()),
          );
        },
                style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: const Text('Add Dispensers'),
      ),
    ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Current Rates:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Petrol: \Rs ${userData['petrol_rate']} per liter'),
                        Text(
                            'Diesel: \Rs ${userData['diesel_rate']} per liter'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Purchase Fuel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PurchasePetrolPage()),
                                );
                              },
                              child: Text('Petrol'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PurchaseDieselPage()),
                                );
                              },
                              child: Text('Diesel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FuelUpdatePage()),
                                );
                              },
                              child: Text('Update Fuel'),
                            ),
                          ],
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
              selectedItemColor: Colors.blue,
            ),
          );
        }
      },
    );
  }
}

