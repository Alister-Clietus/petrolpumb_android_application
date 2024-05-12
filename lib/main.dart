import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iotapp/homepage.dart';
import 'package:iotapp/signup.dart';
import 'package:iotapp/user.dart';
import 'package:provider/provider.dart'; // Add this import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // Wrap MaterialApp with ChangeNotifierProvider
      create: (context) => UserState(), // Provide the UserState globally
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
      ),
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
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your username',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
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
                          String username = usernameController.text;
                          String password = passwordController.text;

                          if (username.isNotEmpty && password.isNotEmpty) 
                          {
                              Map<String, String> data = 
                              {
                                'username': username,
                                'password': password,
                              };

                            var response = await http.post
                            (
                              Uri.parse('http://10.0.2.2:8000/auth/login/'),
                              headers: <String, String>
                              {
                                'Content-Type':'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(data),
                            );

                            if (response.statusCode == 200) 
                            {
                              Map<String, dynamic> responseData =jsonDecode(response.body);
                              if (responseData['message'] == 'successful') 
                              {
                                Provider.of<UserState>(context, listen: false)
                                    .setUserName(username); // Set the username globally
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserPage(username: username),
                                  ),
                                );
                              } else if(responseData['message'] == 'adminsuccessful')
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(username: username),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Loginad As Admin'),
                                  ),
                                );
                              }
                              else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login Failed'),
                                  ),
                                );
                              }
                            } 
                            else 
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login Failed'),
                                ),
                              );
                            }
                          } 
                          else 
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Username and password are required'),
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
                              builder: (context) => const SignupPage(),
                            ),
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

class UserState extends ChangeNotifier {
  String? username;

  void setUserName(String name) {
    username = name;
    notifyListeners();
  }
}
