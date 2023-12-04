// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:http/http.dart' as http;
import 'package:midoku/screens/login.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
                  controller: _password1Controller,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Set oval-like shape
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: _password2Controller,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                    String password1 = _password1Controller.text;
                    String password2 = _password2Controller.text;

                    final response = await request.postJson("http://127.0.0.1:8000/auth/register/", 
                    jsonEncode(<String, String>{
                      'username': username,
                      'password1': password1,
                      'password2': password2,
                      })
                    );

                    if (response['status']) {
                      // Handle successful registration
                      // You can parse the response body if needed
                      String message = "Registration successful!";
                      String uname = username;
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text("$message Welcome, $uname.")),
                        );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    } else {
                      // Handle registration failure
                      String errorMessage = response['message'];
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
