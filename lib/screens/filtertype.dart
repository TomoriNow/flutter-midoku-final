import 'package:flutter/material.dart';
import 'package:midoku/models/book.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/screens/catalog.dart';

class FilterTypePage extends StatefulWidget {
  const FilterTypePage({Key? key});

  @override
  State<FilterTypePage> createState() => _FilterTypePageState();
}

enum Type { MANGA, MANHWA, NOVEL }

class _FilterTypePageState extends State<FilterTypePage> {
  List<Type> selectedTypes = [];
  List<Book> filteredBooks = [];
  List<Book> bookList = [];

  @override
  void initState() {
    super.initState();
    // Fetch books once when the widget is created
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final request = context.read<CookieRequest>();
    final response =
        await request.get('https://galihsopod.pythonanywhere.com/flutter-catalog/');

    setState(() {
      bookList = []; // Clear existing data
      for (var d in response) {
        if (d != null) {
          bookList.add(Book.fromJson(d));
        }
      }
      // Initialize filteredBooks with all books
      filteredBooks = List.from(bookList);
    });
  }

  void updateFilteredBooks() {
    setState(() {
      if (selectedTypes.isEmpty) {
        // No types selected, show all books
        filteredBooks = List.from(bookList);
      } else {
        // Filter books based on selected types
        filteredBooks = bookList.where((book) {
          return selectedTypes.any((selectedType) =>
              book.type.toString() == selectedType.toString());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filter by Types',
        ),
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
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: Type.values.map((type) {
                return FilterChip(
                  label: Text(type.toString().split('.').last),
                  selected: selectedTypes.contains(type),
                  onSelected: (selected) {
                    if (selected) {
                      selectedTypes.add(type);
                    } else {
                      selectedTypes.remove(type);
                    }
                    updateFilteredBooks();
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final catalogBook = filteredBooks[index];
                return catalogBook.buildCatalogWidget(context);
              },
            ),
          ),
        ],
      ),),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CatalogPage(),
                  ),
                );
              },
              heroTag: null,
              label: const Text('Catalog'),
              icon: const Icon(Icons.home_outlined),
            ),
          ),
        ]
      ),
    );
  }
}
