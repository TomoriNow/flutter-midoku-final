import 'package:flutter/material.dart';
import 'package:midoku/screens/admin_landing.dart';
import 'package:midoku/screens/catalog.dart';
import 'package:midoku/screens/collection.dart';
import 'package:midoku/screens/login.dart';
import 'package:midoku/screens/other_users.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/models/current_user.dart';
import 'package:midoku/screens/add_bookpost.dart';
import 'package:midoku/screens/add_tagpost.dart';
import 'package:midoku/screens/other_users_admin.dart';
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({Key? key});
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Future<CurrentUser?> fetchCurrentUser() async {
      final response = await request.get('https://galihsopod.pythonanywhere.com/current-user/');
      if (response != null) {
        return CurrentUser.fromJson(response);
      }
      return null;
    }

    return Drawer(
      child: FutureBuilder(
        future: fetchCurrentUser(),
        builder: (context, snapshot) {
          
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No User data available.'));
          } else {
            final currentUser = snapshot.data as CurrentUser;

            return ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'M I D O K U',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Text(
                        'Your go-to reading partner!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Catalog Page'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CatalogPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.checklist),
                  title: const Text('Collection Page'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CollectionPage(username: snapshot.data?.username),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text('Post Book Suggestion'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddBookPostPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: const Text('Post Tag Suggestion'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTagPostPage(),
                      ),
                    );
                  },
                ),
                if (currentUser.isStaff == true)
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Admin Page'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminLandingPage(),
                        ),
                      );
                    },
                  ),
                  if (currentUser.isStaff == true)
                ListTile(
                  leading: const Icon(Icons.supervisor_account),
                  title: const Text('Other Users'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Other_userPageAdmin(),
                      ),
                    );
                  },
                ),
                if (currentUser.isStaff != true)
                ListTile(
                  leading: const Icon(Icons.supervisor_account),
                  title: const Text('Other Users'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Other_userPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    final response = await request.logout("https://galihsopod.pythonanywhere.com/auth/logout/");
                    String message = response["message"];
                    if (response['status']) {
                      String uname = response["username"];
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("$message Good bye, $uname."),
                      ));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("$message"),
                      ));
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
