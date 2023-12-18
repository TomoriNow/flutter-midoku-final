import 'package:flutter/material.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/models/user.dart';
import 'package:midoku/screens/other_users_collection_admin.dart';
class Other_userPageAdmin extends StatefulWidget {
  const Other_userPageAdmin({Key? key}) : super(key: key);

  @override
  _OtherUserPageStateAdmin createState() => _OtherUserPageStateAdmin();
}

class _OtherUserPageStateAdmin extends State<Other_userPageAdmin> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    Future<List<User>> fetchItem() async {
      final response = await request.get('https://galihsopod.pythonanywhere.com/other-users/');
      // convert the JSON to Item object
      List<User> list_item = [];
      for (var d in response) {
        if (d != null) {
          list_item.add(User.fromJson(d));
        }
      }
      return list_item;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Other User Page',
        ),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchItem(),
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Access the error information
            var error = snapshot.error;

            // Handle the error condition
            return Text('Error: $error');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No User data available.'));
          } else {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final user = snapshot.data![index];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors
                          .green, // Set the background color for the ListTile
                      child: ListTile(
                        title: Text(
                          user.fields.username,
                          style: TextStyle(
                            color: Colors.white, // Set the text color to white
                            fontWeight: FontWeight.bold, // Make the text bold
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            String theUsername = user.fields.username;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtherUserCollectionPageAdmin(
                                  username: theUsername,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .white, // Set the background color for the button
                          ),
                          child: Text(
                            "Show ${user.fields.username}'s Catalog",
                            style: TextStyle(
                              color:
                                  Colors.green, // Set the text color to green
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}