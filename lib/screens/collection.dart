import 'package:flutter/material.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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
        title: const Text('Item'),
      ),
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
            return const Center(child: Text('No item data available.'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final bookEntry = snapshot.data![index];
                return bookEntry.buildEntryWidget();
              },
            );
          }
        },
      ),
    );
  }
}