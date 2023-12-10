import 'package:flutter/material.dart';
import 'package:midoku/screens/filterbook.dart';
import 'package:midoku/screens/filtertype.dart';
import 'package:midoku/screens/searchPage.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/models/book.dart';
import 'package:midoku/widgets/left_drawer.dart';


class CatalogPage extends StatefulWidget {
    const CatalogPage({Key? key}) : super(key: key);

    @override
    _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  Future<List<Book>> fetchItem() async {
      final request = context.watch<CookieRequest>();
      final response = await request.get('https://galihsopod.pythonanywhere.com/flutter-catalog/');

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
          'Catalog Page',
        ),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchItem(),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
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
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 30.0,
            bottom: 16.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilterBookPage(),
                  ),
                );
              },
              heroTag: null,
              label: const Text('Filter by tags'),
              icon: const Icon(Icons.filter_alt),
            ),
          ),
          Positioned(
            left: 200.0,
            bottom: 16.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilterTypePage(),
                  ),
                );
              },
              heroTag: null,
              label: const Text('Filter by type'),
              icon: const Icon(Icons.my_library_books),
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              heroTag: null,
              label: const Text('Search'),
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}
