import 'package:flutter/material.dart';
import 'package:midoku/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/models/user.dart';
import 'package:http/http.dart' as http;

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
    final request = context.watch<CookieRequest>();
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
                  label: Text('Delete User'),
                ),
                DataColumn(
                  label: Text('Make Admin'),
                ),
                DataColumn(
                  label: Text('Revoke Admin'),
                ),
              ],
              rows: snapshot.data!.map((user) {
                List<DataCell> cells = [
                DataCell(Text(user.fields.username)),
                DataCell(ElevatedButton(  
                  child: Text("Show ${user.fields.username}'s Catalog"),  
                  onPressed: () {}
                )),
                DataCell(
                  ElevatedButton( 
                    child: const Text('Delete User'),  
                    onPressed: () async {
                      print(user.fields.username);
                      final response = await request.post('http://127.0.0.1:8000/delete_user_flutter/${Uri.encodeComponent(user.fields.username)}/', {"status": "success"});
                    }
                  )
                ),
              ];
              if (user.fields.isStaff==false && user.fields.isSuperuser) {
                cells.add (DataCell(
                    ElevatedButton(  
                      child: const Text('Make Admin'),  
                      onPressed: () async {
                        final response = await request.post('http://127.0.0.1:8000/make_admin_flutter/${Uri.encodeComponent(user.fields.username)}/', {"status": "success"});
                      }
                    )
                  )
                );
              } else {
                cells.add(const DataCell(Text('Already an admin')));
              }

              if (user.fields.isStaff && user.fields.isSuperuser == true) {
                cells.add(
                  DataCell(
                    ElevatedButton(  
                      child: const Text('Revoke Admin'),  
                      onPressed: () async {
                        final response = await request.post('http://127.0.0.1:8000/make_admin_flutter/${Uri.encodeComponent(user.fields.username)}/', {"status": "success"});
                      }
                    ),
                  ),
                );
              } else {
                cells.add(const DataCell(Text('Not an admin')));
              }

              return DataRow(cells: cells);
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