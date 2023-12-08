import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:midoku/models/bookpost.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/screens/manage_bookposts.dart';

class DetailBookpostPage extends StatefulWidget {
  final Bookpost bookPost;
  const DetailBookpostPage({Key? key, required this.bookPost}) : super(key: key);

  @override
  _DetailBookpostPageState createState() => _DetailBookpostPageState();
}

class _DetailBookpostPageState extends State<DetailBookpostPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Bookpost bookPost = widget.bookPost;

    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Detailed Book Suggestion Page',
          ),
        ),
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${bookPost.name} ",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "by ${bookPost.author}",
                            style: const TextStyle(
                              fontSize: 15,
                              // Add other styling properties for the author
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                      bookPost.imagelink, 
                      width: 250, 
                      height: 400, 
                      fit: BoxFit.contain, 
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/logos.png',
                          width: 200.0,
                          height: 100.0,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Type:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bookPost.type,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Description:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bookPost.description,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Tags:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bookPost.taggits.join(", "),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(  
                      child: const Text('Accept Book'),
                      onPressed: () async {
                        print(Uri.encodeComponent(bookPost.id.toString()));
                        final response = await request.post('http://127.0.0.1:8000/accept-book-flutter/${Uri.encodeComponent(bookPost.id.toString())}/', {"status": "success"});
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageBookpostsPage()),
                        );
                      }
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(  
                      child: const Text('Reject Book'),  
                      onPressed: () async {
                        print(Uri.encodeComponent(bookPost.id.toString()));
                        final response = await request.post('http://127.0.0.1:8000/reject-book-flutter/${Uri.encodeComponent(bookPost.id.toString())}/', {"status": "success"});
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageBookpostsPage()),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
