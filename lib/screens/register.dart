// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:http/http.dart' as http;
import 'package:midoku/screens/login.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          elevation: 5.0,
          shadowColor: Colors.black, // Set the shadow color (optional)
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Set border radius (optional)
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: 300.0,
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color
              borderRadius:
                  BorderRadius.circular(10.0), // Set border radius (optional)
              boxShadow: [
                BoxShadow(
                  color: Colors.grey
                      .withOpacity(0.5), // Set shadow color and opacity
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // Set the shadow offset
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logos.png', // Replace with your image path
                  width: 200.0, // Set the width of the image
                  height: 100.0, // Set the height of the image
                  fit: BoxFit.cover, // Adjust the BoxFit as needed
                ),
                const SizedBox(height: 30.0),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Set oval-like shape
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Set oval-like shape
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () async {
                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    final response = await http.post(
                      Uri.parse("http://127.0.0.1:8000/auth/register/"),
                      body: {
                        'username': username,
                        'password': password,
                      },
                    );

                    if (response.statusCode == 200) {
                      // Handle successful registration
                      // You can parse the response body if needed
                      String message = "Registration successful!";
                      String uname = username;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text("$message Welcome, $uname.")),
                        );
                    } else {
                      // Handle registration failure
                      String errorMessage =
                          jsonDecode(response.body)['message'];
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Registration Failed'),
                          content: Text(errorMessage),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
