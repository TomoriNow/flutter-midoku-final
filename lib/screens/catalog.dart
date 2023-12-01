import 'package:flutter/material.dart';
import 'package:midoku/screens/login.dart';
import 'package:midoku/main.dart';
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
      final response = await request.get('http://127.0.0.1:8000/flutter-catalog/');

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
