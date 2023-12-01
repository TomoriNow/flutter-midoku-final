// import 'package:shopping_list/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:midoku/screens/catalog.dart';
import 'package:midoku/main.dart';
import 'package:midoku/screens/register.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/screens/collection.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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

                    // Check credentials
                    // TODO: Change the URL and don't forget to add a trailing slash (/) at the end of the URL!
                    // To connect the Android emulator to Django on localhost,
                    // use the URL http://10.0.2.2/
                    final response = await request
                        .login("http://127.0.0.1:8000/auth/login/", {
                      'username': username,
                      'password': password,
                    });

                    if (request.loggedIn) {
                      String message = response['message'];
                      String uname = response['username'];
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CatalogPage()),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text("$message Welcome, $uname.")),
                        );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Login Failed'),
                          content: Text(response['message']),
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
                  child: const Text('Login'),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom:
                          16.0), // Adjust the value for your desired spacing
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text('Create an account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
