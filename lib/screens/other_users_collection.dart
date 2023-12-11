import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:midoku/widgets/book_entry_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:midoku/screens/view_page.dart';
import 'package:midoku/screens/other_users.dart';
import 'package:midoku/screens/favourite_book_page.dart';



class OtherUserCollectionPage extends StatefulWidget {
  final String username;
  const OtherUserCollectionPage({Key? key, required this.username}) : super(key: key);

  @override
  _OtherUserCollectionPageState createState() => _OtherUserCollectionPageState();
}

class _OtherUserCollectionPageState extends State<OtherUserCollectionPage> {
  
  Future<List<BookEntry>> fetchItem() async {
    // TODO: Change the URL to your Django app's URL. Don't forget to add the trailing slash (/) if needed.
    final request = context.watch<CookieRequest>();
    var encodedUsername = Uri.encodeComponent(widget.username);
    var url = 'http://127.0.0.1:8000/entry_flutter/$encodedUsername/';
    var response = await request.get(url);
    // decode the response to JSON

    // convert the JSON to Item object
    List<BookEntry> listItem = [];
    for (var d in response) {
        if (d != null) {
          listItem.add(BookEntry.fromJson(d));
        }
    }
    return listItem;
  }
  @override
  Widget build(BuildContext context) {
    String temp_var = widget.username;
    return Scaffold(
      appBar: AppBar(
        title: Text("$temp_var's Collection Page"),
        backgroundColor: Colors.greenAccent,
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
              Colors.greenAccent,
            ],
          ),
        ),
        child: FutureBuilder(
          future: fetchItem(),
          builder: (context, AsyncSnapshot<List<BookEntry>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {// Access the error information
              var error = snapshot.error;
              // Handle the error condition
              return Text('Error: $error');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('$temp_var has no books in their collection.'));
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final bookEntry = snapshot.data![index];
                  return Card(
                    surfaceTintColor: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 10,
         child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5), // Adjust the opacity as needed
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // You can adjust the offset to control the direction of the glow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child:  Stack(
          children: [BookEntryCard(bookEntry: bookEntry),Positioned(
              top: 8.0,
              right: 8.0,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () async {
                      // Handle icon button press
                      final bool? shouldRefresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPage(bookEntry: bookEntry),
                        ),
                      );
                      if (shouldRefresh != null && shouldRefresh) {
                        // Refresh the card by calling setState
                        setState(() {});
                      }
                    },
                  ), 
                ]
              )
            ),
          ],
        ),
                  ),);
                },
              );
            }
          },
        ),
      ),
      
      floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
  
        FloatingActionButton.extended(
        heroTag: "button1",
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Other_userPage()),
          );
        },
        label: const Text('Back'),
        icon: const Icon(Icons.arrow_back),
      ),
    const SizedBox(width: 16), // Adjust spacing if needed
    FloatingActionButton.extended(
      heroTag: "button2",
      onPressed: () async {
        // Navigate to the screen displaying user's favorite books
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavouriteBookPage(username: widget.username)),
        );
      },
      label: const Text('Favourite Book'),
      icon: const Icon(Icons.favorite),
    ),
  ],
      )
    );
  }
}