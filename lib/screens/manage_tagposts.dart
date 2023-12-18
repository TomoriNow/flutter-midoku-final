// manage_tagposts.dart

import 'package:flutter/material.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/models/tagpost.dart'; // Import your Tagpost model
import 'package:midoku/screens/detailed_tagpost.dart'; // Import your DetailedTagpostPage

class ManageTagPostsPage extends StatefulWidget {
  const ManageTagPostsPage({Key? key}) : super(key: key);

  @override
  _ManageTagPostsPageState createState() => _ManageTagPostsPageState();
}

class _ManageTagPostsPageState extends State<ManageTagPostsPage> {
  Future<List<Tagpost>> fetchItem() async {
    final request = context.watch<CookieRequest>();
    final response = await request.get('https://galihsopod.pythonanywhere.com/tagpost-list/');

    List<Tagpost> list_item = [];
    for (var d in response) {
      if (d != null) {
        list_item.add(Tagpost.fromJson(d));
      }
    }
    return list_item;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tag Post Management Page',
        ),
        backgroundColor: Colors.blueAccent, // Customize the color as needed
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchItem(),
        builder: (context, AsyncSnapshot<List<Tagpost>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error condition
            var error = snapshot.error;
            return Text('Error: $error');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Tagpost data available.'));
          } else {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final tagpost = snapshot.data![index];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.blue, // Customize the color as needed
                      child: ListTile(
                        title: Text(
                          tagpost.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailedTagpostPage(tagPost: tagpost),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          child: Text(
                            "View ${tagpost.tag}",
                            style: const TextStyle(
                              color: Colors.blue,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Return to the previous page
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
