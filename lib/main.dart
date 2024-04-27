import 'package:flutter/material.dart';
import 'package:iotapp/map.dart';
import 'package:iotapp/purchase_diesel_page.dart';
import 'package:iotapp/purchase_petrol_page.dart';
import 'package:iotapp/recharge_page.dart';
import 'package:iotapp/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.blue,
                ),
                SizedBox(height: 10),
                Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your username',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Login logic
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                name: 'John Doe',
                                phoneNumber: '1234567890',
                                email: 'john.doe@example.com',
                                totalPetrolBought: 100.0,
                                walletBalance: 500.0,
                              ),
                            ),
                          );
                        },
                        child: Text('Login'),
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () 
                        {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()),
                          );
                        },
                        child: Text('Sign Up'),
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
  final String name;
  final String phoneNumber;
  final String email;
  final double totalPetrolBought;
  final double walletBalance;

  HomePage({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.totalPetrolBought,
    required this.walletBalance,
  });
  int _selectedIndex =
      0; // Index of the selected item in the bottom navigation bar

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
        title: Text('Welcome, $name'),
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
                      Text(
                        'Profile Details:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Name: $name'),
                      Text('Phone Number: $phoneNumber'),
                      Text('Email: $email'),
                      Text('Total Petrol Bought: $totalPetrolBought liters'),
                      Text('Wallet Balance: \$ $walletBalance'),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                      'https://banner2.cleanpng.com/20180329/zue/kisspng-computer-icons-user-profile-person-5abd85306ff7f7.0592226715223698404586.jpg'), // Replace with the URL of your image
                ),
              ],
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
                        launchMap(context);
                      // Navigate to the locate page
                    },
                    child: Text('Locate'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RechargePage()),
                      );

                      // Navigate to the recharge page
                    },
                    child: Text('Recharge'),
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
              padding: EdgeInsets.all(10),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Petrol: \$2.5 per liter'),
                  Text('Diesel: \$2.0 per liter'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                builder: (context) => PurchasePetrolPage()),
                          );
                        },
                        child: Text('Petrol'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PurchaseDieselPage()),
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
                    'https://content.jdmagicbox.com/comp/mahabubnagar/h1/9999p8542.8542.180101024549.i8h1/catalogue/hp-petrol-pump-utkur-mahabubnagar-petrol-pumps-7io33jsg2e.jpg', // Replace with the URL of your logo
                    width: 100, // Adjust the width as needed
                    height: 100, // Adjust the height as needed
                  ),
                  Image.network(
                    'https://t3.ftcdn.net/jpg/03/01/49/32/360_F_301493277_7H7JI9juC6u2jKUJBEBuenoQB0uH5Ub3.jpg', // Replace with the URL of your logo
                    width: 100, // Adjust the width as needed
                    height: 100, // Adjust the height as needed
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
}
