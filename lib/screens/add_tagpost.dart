import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/models/tags.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddTagPostPage extends StatefulWidget {
  const AddTagPostPage({Key? key}) : super(key: key);

  @override
  _AddTagPostPageState createState() => _AddTagPostPageState();
}

class _AddTagPostPageState extends State<AddTagPostPage> {
  final _formKey = GlobalKey<FormState>();
  String _customTag = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Submit Custom Tag',
          ),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Custom Tag",
                    labelText: "Custom Tag",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _customTag = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Custom Tag cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Send request to Django and wait for the response
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/create-tagpost-flutter/",
                          jsonEncode(<String, dynamic>{
                            'tag': _customTag,
                          }),
                        );

                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Custom Tag successfully submitted!",
                              ),
                            ),
                          );
                          // Optional: You can add a pop-up dialog here
                          // to inform the user about successful submission.
                          Navigator.of(context).pop(true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Something went wrong, please try again.",
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
