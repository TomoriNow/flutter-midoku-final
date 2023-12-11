import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/models/book.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/screens/login.dart';
import 'package:midoku/screens/add_to_collection_page.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:midoku/widgets/book_entry_card.dart';
class FavouriteBookPage extends StatefulWidget {
  final String username;
  const FavouriteBookPage({Key? key, required this.username}) : super(key: key);

  @override
  _FavouriteBookPageState createState() => _FavouriteBookPageState();
}

class _FavouriteBookPageState extends State<FavouriteBookPage> {
  late Future<BookEntry> _bookEntry;

  Future<BookEntry> fetchItem() async {
    final request = context.watch<CookieRequest>();
    var encodedUsername = Uri.encodeComponent(widget.username);
    var url = 'http://127.0.0.1:8000/favourite-entry-flutter-get/$encodedUsername/';
    var response = await request.get(url);
    return BookEntry.fromJson(response);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bookEntry = fetchItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Page'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _bookEntry,
        builder: (context, AsyncSnapshot<BookEntry> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            var error = snapshot.error;
            print(error);
            return Text('Error: $error');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('You have no books in your collection.'));
          } else {
            final bookEntry = snapshot.data!;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              elevation: 10,
              child: BookEntryCard(bookEntry: bookEntry),
            );
          }
        },
      ),
    );
  }
}
