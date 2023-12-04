import 'package:flutter/material.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:midoku/screens/add_custom_entry.dart';
import 'package:midoku/widgets/book_entry_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/widgets/left_drawer.dart';

class CollectionPage extends StatefulWidget {
    const CollectionPage({Key? key}) : super(key: key);

    @override
    _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  Future<List<BookEntry>> fetchItem() async {
    // TODO: Change the URL to your Django app's URL. Don't forget to add the trailing slash (/) if needed.
    final request = context.watch<CookieRequest>();
    var response = await request.get(
      'http://127.0.0.1:8000/Galih/'
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Page'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchItem(),
        builder: (context, AsyncSnapshot<List<BookEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {// Access the error information
            var error = snapshot.error;
            // Handle the error condition
            return Text('Error: $error');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have no books in your collection.'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final bookEntry = snapshot.data![index];
                return BookEntryCard(bookEntry: bookEntry);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final bool? shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomPage()),
          );
          if (shouldRefresh != null && shouldRefresh) {
                  setState(() {});
                }
        },
        label: const Text('Add Custom Entry'),
        icon: const Icon(Icons.add),
      )
    );
  }
}