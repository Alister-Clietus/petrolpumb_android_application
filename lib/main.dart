import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iotapp/map.dart';
import 'package:iotapp/purchase_diesel_page.dart';
import 'package:iotapp/purchase_petrol_page.dart';
import 'package:iotapp/recharge_page.dart';
import 'package:iotapp/signup.dart';
import 'package:iotapp/update_rates.dart';
import 'package:iotapp/wallet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
                Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller:
                      usernameController, // Assign controller to text field
                  decoration: const InputDecoration(
                    hintText: 'Enter your username',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller:
                      passwordController, // Assign controller to text field
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Get the username and password from the text fields
                          String username = usernameController.text;
                          String password = passwordController.text;

                          // Ensure both fields are not empty before proceeding
                          if (username.isNotEmpty && password.isNotEmpty) {
                            // Create a map containing the username and password
                            Map<String, String> data = {
                              'username': username,
                              'password': password,
                            };
                            // Send a POST request to the server
                            // Check if the request was successful
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  username:
                                      username,
                                       // Use username as name for simplicity
                                ),
                              ),
                            );
                          } else {
                            // Show a snackbar indicating login failed
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login Failed'),
                              ),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()),
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username});

  Future<Map<String, dynamic>> fetchUserData(String username) async {
    final userDataResponse = await http.get(Uri.parse('http://127.0.0.1:8000/auth/user/$username/'));
    final ratesResponse = await http.get(Uri.parse('http://127.0.0.1:8000/petrol/rate/'));
    
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
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchUserData(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // or any loading indicator
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
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
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            'https://banner2.cleanpng.com/20180329/zue/kisspng-computer-icons-user-profile-person-5abd85306ff7f7.0592226715223698404586.jpg'), // Replace with the URL of your image
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            launchMap(context);
                            // Navigate to the locate page
                          },
                          child: Text('Locate'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WalletPage()),
                            );

                            // Navigate to the recharge page
                          },
                          child: const Text('Recharge'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Box for Locate and Recharge buttons
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FuelUpdatePage()),
                            ); // Navigate to the locate page
                          },
                          child: Text('Update Petrol'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FuelUpdatePage()),
                            );

                            // Navigate to the recharge page
                          },
                          child: const Text('Update Diesel'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Current Rates:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Box to display current rates
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Petrol: \Rs ${userData['petrol_rate']} per liter'),
                        Text('Diesel: \Rs ${userData['diesel_rate']} per liter'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
                          // Place the buttons in a Row widget
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Box for Locate and Recharge buttons
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.network(
                          'https://t4.ftcdn.net/jpg/03/01/49/33/360_F_301493309_uuT73jRnsbKEXa3mZSBc5bvwB07Rkp7U.jpg', // Replace with the URL of your logo
                          width: 100, // Adjust the width as needed
                          height: 100, // Adjust the height as needed
                        ),
                        Image.network(
                          'https://t4.ftcdn.net/jpg/03/01/49/33/360_F_301493309_uuT73jRnsbKEXa3mZSBc5bvwB07Rkp7U.jpg', // Replace with the URL of your logo
                          width: 100, // Adjust the width as needed
                          height: 100, // Adjust the height as needed
                        ),
                        Image.network(
                          'https://t4.ftcdn.net/jpg/03/01/49/33/360_F_301493309_uuT73jRnsbKEXa3mZSBc5bvwB07Rkp7U.jpg', // Replace with the URL of your logo
                          width: 100, // Adjust the width as needed
                          height: 100, // Adjust the height as needed
                        ),
                      ],
                    ),
                  ),
                  // Rest of your widget code...
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
              // currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              // onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}