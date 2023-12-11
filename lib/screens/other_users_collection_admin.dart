import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:midoku/widgets/book_entry_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:midoku/screens/view_page.dart';
import 'package:midoku/screens/favourite_book_page.dart';
import 'package:midoku/screens/other_users_admin.dart';
class OtherUserCollectionPageAdmin extends StatefulWidget {
  final String username;
  const OtherUserCollectionPageAdmin({Key? key, required this.username}) : super(key: key);

  @override
  _OtherUserCollectionPageStateAdmin createState() => _OtherUserCollectionPageStateAdmin();
}

class _OtherUserCollectionPageStateAdmin extends State<OtherUserCollectionPageAdmin> {
  Future<List<BookEntry>> fetchItem() async {
    final request = context.watch<CookieRequest>();
    var encodedUsername = Uri.encodeComponent(widget.username);
    var url = 'http://127.0.0.1:8000/entry_flutter/$encodedUsername/';
    var response = await request.get(url);
    
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
    String tempVar = widget.username;
    return Scaffold(
      appBar: AppBar(
        title: Text("$tempVar's Collection Page"),
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
        child:FutureBuilder(
          future: fetchItem(),
          builder: (context, AsyncSnapshot<List<BookEntry>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              var error = snapshot.error;
              return Text('Error: $error');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('You have no books in your collection.'));
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
                    child: Stack(
                      children: [
                        BookEntryCard(bookEntry: bookEntry),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.info),
                                onPressed: () async {
                                  final bool? shouldRefresh = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewPage(bookEntry: bookEntry),
                                    ),
                                  );
                                  if (shouldRefresh != null && shouldRefresh) {
                                    setState(() {});
                                  }
                                },
                              ),
                              IconButton(
                                onPressed: () async {
                                  final request = Provider.of<CookieRequest>(context, listen: false);
                                  final response = await request.postJson(
                                    "http://127.0.0.1:8000/delete-entry-flutter/",
                                    jsonEncode(<String, dynamic>{'id': bookEntry.pk}),
                                  );
                                  if (response['status'] == 'success') {
                                    setState(() {
                                      snapshot.data!.removeAt(index);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Something went wrong, please try again."),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
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
            MaterialPageRoute(builder: (context) => const Other_userPageAdmin()),
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
