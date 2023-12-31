import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:midoku/screens/add_custom_entry.dart';
import 'package:midoku/screens/detailed_entry.dart';
import 'package:midoku/widgets/book_entry_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:midoku/screens/favourite_book_page.dart';
class CollectionPage extends StatefulWidget {
    final username;
    const CollectionPage({Key? key, required this.username}) : super(key: key);

    @override
    _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  late Future<List<BookEntry>> _bookEntries;
  Future<List<BookEntry>> fetchItem() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    var response = await request.get('https://galihsopod.pythonanywhere.com/Galih/');
    List<BookEntry> listItem = [];
    for (var d in response) {
      if (d != null) {
        listItem.add(BookEntry.fromJson(d));
      }
    }
    return listItem;
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bookEntries = fetchItem();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Page'),
        backgroundColor: Colors.redAccent,
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
        future: _bookEntries,
        builder: (context, AsyncSnapshot<List<BookEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {// Access the error information
            var error = snapshot.error;
            print(error);
            // Handle the error condition
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
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      elevation: 10,
      child:  Container(
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
        children: [Padding(padding: const EdgeInsets.only(top: 4.5), child: BookEntryCard(bookEntry: bookEntry)),
        Positioned(
            top: 0.0,
            right: 0.0,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () async {
                    // Handle icon button press
                    final bool? shouldRefresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailEntryPage(bookEntry: bookEntry),
                      ),
                    );
                    if (shouldRefresh != null && shouldRefresh) {
                      // Refresh the card by calling setState
                      setState(() {});
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.star),
                  onPressed: () async {
                    // Handle icon button press
                  final request = Provider.of<CookieRequest>(context, listen: false);
                  await request.postJson(
                    "https://galihsopod.pythonanywhere.com/favourite-entry-flutter-post/",
                    jsonEncode(<String, dynamic>{
                      'id': bookEntry.pk,
                      'username': widget.username
                    })
                  );
                  },
                ),
                IconButton(onPressed: () async {
                  final request = Provider.of<CookieRequest>(context, listen: false);
                  final response = await request.postJson(
                    "https://galihsopod.pythonanywhere.com/delete-entry-flutter/",
                    jsonEncode(<String, dynamic>{
                      'id': bookEntry.pk,
                    })
                  );
                  if (response['status'] == 'success') {
                    setState(() {
                      snapshot.data!.removeAt(index);
                    });
                  } else {
                    ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                      content:
                        Text("Something went wrong, please try again."),
                    ));
                  }
                }, icon: Icon(Icons.delete))
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
      onPressed: () async {
        final bool? shouldRefresh = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCustomPage()),
        );
        if (shouldRefresh != null && shouldRefresh) {
          setState(() {
            _bookEntries = fetchItem();
          });
        }
      },
      label: const Text('Add Custom Entry'),
      icon: const Icon(Icons.add),
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