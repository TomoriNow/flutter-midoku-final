import 'package:flutter/material.dart';
import 'package:midoku/widgets/admin_card.dart';
import 'package:midoku/widgets/left_drawer.dart';

class AdminLandingPage extends StatelessWidget {
  AdminLandingPage({Key? key}) : super(key: key);

  final List<AdminItem> items = [
    AdminItem("Manage Users", Icons.supervised_user_circle, Colors.green),
    AdminItem("Manage Book Posts", Icons.book, Colors.lightGreen),
    AdminItem("Manage Tag Posts", Icons.content_copy, Colors.greenAccent)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Landing Page',
        ),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        // Scrolling wrapper widget
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding for the page
          child: Column(
            // Widget to display children vertically
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                // Text widget to display text with center alignment and appropriate style
                child: Text(
                  'Admin Landing Page', // Text indicating the shop name
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid layout
              GridView.count(
                // Container for our cards.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((AdminItem item) {
                  // Iteration for each item
                  return AdminCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
