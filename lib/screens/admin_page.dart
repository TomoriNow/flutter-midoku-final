import 'package:flutter/material.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/models/user.dart';


class AdminPage extends StatefulWidget {
    const AdminPage({Key? key}) : super(key: key);

    @override
    _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Future<List<User>> fetchItem() async {
      final request = context.watch<CookieRequest>();
      final response = await request.get('http://127.0.0.1:8000/other-users/');

      // convert the JSON to Item object
      List<User> list_item = [];
      for (var d in response) {
          if (d != null) {
              list_item.add(User.fromJson(d));
          }
      }
      return list_item;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Page',
          ),
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.white,
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
        future: fetchItem(),
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {// Access the error information
          var error = snapshot.error;
          
          // Handle the error condition
          return Text('Error: $error');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No User data available.'));
          } else {
              final dataTable = DataTable(
              columns: const [
                DataColumn(
                  label: Text('Username'),
                ),
                DataColumn(
                  label: Text('Show their Catalog'),
                ),
                DataColumn(
                  label: Text('Modify User'),
                ),
              ],
              rows: snapshot.data!.map((user) {
                return DataRow(
                  cells: [
                  DataCell(Text(user.fields.username)),
                  DataCell(ElevatedButton(  
                        child: Text("Show ${user.fields.username}'s Catalog"),  
                        onPressed: () {}
                    )), // Replace with actual widget
                  DataCell(
                    ElevatedButton(  
                        child: const Text('Delete User'),  
                        onPressed: () {}
                    )),
                ]);
              }).toList(),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10.0),
              ),
              columnSpacing: 100.0, // Adjust column spacing
            );

            return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: dataTable,
                ),
              );
          }
        }
      )
    );
  }
}