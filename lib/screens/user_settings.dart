import 'package:flutter/material.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/models/user.dart';
import 'package:midoku/screens/manage_users.dart';

class UserSettingsPage extends StatefulWidget {
    final User user;

  const UserSettingsPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  User get user => widget.user;
  
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Settings'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue,
                  Colors.purple,
                ],
              ),
            ),
        child: Center(
        child: Card(
          elevation: 10.0,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 200),
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
              width: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.fields.username,
                  style: const TextStyle(
                    fontSize: 24.0, // Increase font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(  
                      child: const Text('Delete User'),  
                      onPressed: () async {
                        final response = await request.post('http://127.0.0.1:8000/delete_user_flutter/${Uri.encodeComponent(user.fields.username)}/', {"status": "success"});
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageUsersPage()),
                        );
                      }
                    ),
                const SizedBox(height: 12),

                if (user.fields.isStaff==false)
                    ElevatedButton(  
                      child: const Text('Make Admin'),  
                      onPressed: () async {
                        final response = await request.post('http://127.0.0.1:8000/make_admin_flutter/${Uri.encodeComponent(user.fields.username)}/', {"status": "success"});
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageUsersPage()),
                        );
                      }
                    ),
                    const SizedBox(height: 12),
                if (user.fields.isStaff==true)
                  const Text('Already an admin', style: TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 12),
                
                if (user.fields.isStaff==true)
                    ElevatedButton(  
                      child: const Text('Revoke Admin'),  
                      onPressed: () async {
                        final response = await request.post('http://127.0.0.1:8000/revoke_admin_flutter/${Uri.encodeComponent(user.fields.username)}/', {"status": "success"});
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageUsersPage()),
                        );
                      }
                    ),
                    const SizedBox(height: 12),
                if (user.fields.isStaff==false)
                  const Text('Not an admin', style: TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 12),
              ],
            ),
          ),),
        ),
      ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Return to the item list page
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
  

