// detailed_tagpost.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/models/tagpost.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/screens/manage_tagposts.dart';

class DetailedTagpostPage extends StatefulWidget {
  final Tagpost tagPost;
  const DetailedTagpostPage({Key? key, required this.tagPost})
      : super(key: key);

  @override
  _DetailedTagpostPageState createState() => _DetailedTagpostPageState();
}

class _DetailedTagpostPageState extends State<DetailedTagpostPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Tagpost tagPost = widget.tagPost;

    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Detailed Tag Post Page',
          ),
        ),
        backgroundColor: Colors.blueAccent, // Customize the color as needed
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
                    Text(
                      "Tag: ${tagPost.tag}",
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Accept Tag'),
                      onPressed: () async {
                        print(Uri.encodeComponent(tagPost.id.toString()));
                        final response = await request.post(
                            'http://127.0.0.1:8000/accept-tag-flutter/${Uri.encodeComponent(tagPost.id.toString())}/',
                            {"status": "success"});
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageTagPostsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      child: const Text('Reject Tag'),
                      onPressed: () async {
                        print(Uri.encodeComponent(tagPost.id.toString()));
                        final response = await request.post(
                            'http://127.0.0.1:8000/reject-tag-flutter/${Uri.encodeComponent(tagPost.id.toString())}/',
                            {"status": "success"});
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageTagPostsPage()),
                        );
                      },
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