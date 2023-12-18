import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:midoku/models/book.dart';
import 'package:midoku/models/tags.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/screens/catalog.dart';

class FilterBookPage extends StatefulWidget {
  const FilterBookPage({Key? key});

  @override
  State<FilterBookPage> createState() => _FilterBookPageState();
}

class _FilterBookPageState extends State<FilterBookPage> {
  List<String> tags = [];
  List<String> selectedTags = [];
  List<Book> filteredBooks = [];
  List<Book> list_item = []; // Declare list_item as a member variable

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
      list_item = []; // Clear existing data
      for (var d in response) {
        if (d != null) {
          list_item.add(Book.fromJson(d));
        }
      }
      // Initialize filteredBooks with all books
      filteredBooks = List.from(list_item);
    });
  }

  Future<List<String>> fetchData() async {
    final request = context.read<CookieRequest>();
    var response = await request.get('https://galihsopod.pythonanywhere.com/fetch-tags/');

    List<String> list = [];
    for (var d in response) {
      if (d != null) {
        list.add(Tag.fromJson(d).fields.name);
      }
    }
    return list;
  }

  void updateFilteredBooks() {
    setState(() {
      filteredBooks = list_item
          .where((book) => selectedTags
              .every((selectedTag) => book.taggits.contains(selectedTag)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filter by Tags',
        ),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        // Assuming you have a different future for fetching tags
        future: fetchData(),
        builder: (context, AsyncSnapshot<List<String>> tagsSnapshot) {
          if (tagsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (tagsSnapshot.hasError) {
            // Handle the error condition for tags
            var error = tagsSnapshot.error;
            return Text('Error fetching tags: $error');
          } else if (!tagsSnapshot.hasData || tagsSnapshot.data!.isEmpty) {
            return const Center(child: Text('No tags data available.'));
          } else {
            tags = tagsSnapshot.data!;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: tags.map((tag) {
                      return FilterChip(
                        label: Text(tag),
                        selected: selectedTags.contains(tag),
                        onSelected: (selected) {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                          updateFilteredBooks();
                        },
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
            );
          }
        },
      ),
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
