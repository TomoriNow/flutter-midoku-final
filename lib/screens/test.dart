import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class YourFlutterScreen extends StatefulWidget {
  @override
  _YourFlutterScreenState createState() => _YourFlutterScreenState();
}

class _YourFlutterScreenState extends State<YourFlutterScreen> {
  String apiResponse = 'Loading...';

  Future<void> fetchData() async {
    final request = context.watch<CookieRequest>();
    final response = await request.get('https://galihsopod.pythonanywhere.com/test/');

    final Map<String, dynamic> data = response;
    setState(() {
      apiResponse = 'API Response: $data';
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DRF Flutter Integration'),
      ),
      body: Center(
        child: Text(apiResponse),
      ),
    );
  }
}