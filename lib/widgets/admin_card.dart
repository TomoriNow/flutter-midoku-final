import 'package:flutter/material.dart';
import 'package:midoku/screens/manage_users.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AdminItem {
  final String name;
  final IconData icon;
  final Color color;

  AdminItem(this.name, this.icon, this.color);
}

class AdminCard extends StatelessWidget {
  final AdminItem item;

  const AdminCard(this.item, {Key? key}); // Constructor

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.color,
      child: InkWell(
        // Responsive touch area
        onTap: () async {
          // Show SnackBar when clicked
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("You pressed the ${item.name} button!")));

          // Navigate to the appropriate route (depending on the button type)
          if (item.name == "Manage Users") {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageUsersPage(),
                ),
              );
          } else if (item.name == "Manage Book Posts") {
              
          } else if (item.name == "Manage Tag Posts") {
            
          }
            
          
        },
        child: Container(
          // Container to hold Icon and Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}