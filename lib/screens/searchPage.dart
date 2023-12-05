import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/models/book.dart';
import 'package:midoku/widgets/left_drawer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<Book>> fetchItem() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final response =
        await request.get('http://127.0.0.1:8000/flutter-catalog/');

    // convert the JSON to Item object
    List<Book> list_item = [];
    for (var d in response) {
      if (d != null) {
        list_item.add(Book.fromJson(d));
      }
    }
    return list_item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Page',
        ),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: SearchPageDelegate(fetchItem()),
              );

              // Handle the result, if needed
              if (result != null) {
                print('Selected item: $result');
              }
            },
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchItem(),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Access the error information
            var error = snapshot.error;

            // Handle the error condition
            return Text('Error: $error');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No item data available.'));
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
                final catalogBook = snapshot.data![index];
                return catalogBook.buildCatalogWidget(context);
              },
            );
          }
        },
      ),
    );
  }
}

// Define a simple delegate for the search page
class SearchPageDelegate extends SearchDelegate<String> {
  final Future<List<Book>> futureBooks;

  SearchPageDelegate(this.futureBooks);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return FutureBuilder(
      future: futureBooks,
      builder: (context, AsyncSnapshot<List<Book>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Access the error information
          var error = snapshot.error;

          // Handle the error condition
          return Text('Error: $error');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No item data available.'));
        } else {
          final List<Book> filteredBooks = snapshot.data!
              .where((book) =>
                  book.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final catalogBook = filteredBooks[index];
              return catalogBook.buildCatalogWidget(context);
            },
          );
        }
      },
    );
  }
}
