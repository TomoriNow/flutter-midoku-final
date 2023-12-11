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
import 'package:midoku/screens/other_users_admin.dart';
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
    print(widget.username);
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
        title:  Text("${widget.username}'s Favourite Book"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
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
        future: _bookEntry,
        builder: (context, AsyncSnapshot<BookEntry> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            var error = snapshot.error;
            if (error.toString() == "Expected a value of type 'String', but got one of type 'Null'"){
              return Center(child: Text("${widget.username} doesn't have a favourite book."));
            }
            print(error);
            return Text('Error: $error');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("${widget.username} doesn't have a favourite book."));
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
      ),
      
      floatingActionButton: 
      FloatingActionButton.extended(
        heroTag: "button1",
        onPressed: () {
          Navigator.pop(
            context
            );
        },
        label: const Text('Back'),
        icon: const Icon(Icons.arrow_back),
      ), 
    );
  }
}
