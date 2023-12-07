import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/models/tags.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddBookPostPage extends StatefulWidget {
    const AddBookPostPage({super.key});

    @override
    _AddBookPostPageState createState() => _AddBookPostPageState();
}

class _AddBookPostPageState extends State<AddBookPostPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _author = "";
  String _imagelink = "";
  List<String> _taggits = [];
  String _description = "";
  List<String> tags = [];
  String? _type;
  
  List<String> types = ["Manga", "Manhwa", "Novel", "Light Novel"];



  Future<List<String>> fetchData() async {
    final request = context.watch<CookieRequest>();
    var response = await request.get(
      'http://127.0.0.1:8000/fetch-tags/'
    );
    
    List<String> list = [];
    for (var d in response) {
      if (d != null) {
        list.add(Tag.fromJson(d).fields.name);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Post Book Suggestion Form',
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
                    hintText: "Book Title",
                    labelText: "Book Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Book Title cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Author",
                    labelText: "Author",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _author = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Book Author cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _type,
                  decoration: InputDecoration(
                    hintText: "Type",
                    labelText: "Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _type = value;
                    });
                  },
                  items: types.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Book Type cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Link for Image",
                    labelText: "Link for Image",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _imagelink = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Image Link cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Description cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Text("Tags:"),
              FutureBuilder(
                future: fetchData(), 
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (!snapshot.hasData) {
                      return const Column(
                        children: [
                          Text(
                            "No item data available.",
                            style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                          ),
                          SizedBox(height: 8),
                        ],
                      );
                    } else {
                      List<String> tags = snapshot.data;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          children: tags.map((tag) {
                            return FilterChip(
                              label: Text(tag),
                              selected: _taggits.contains(tag),
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _taggits.add(tag);
                                  } else {
                                    _taggits.remove(tag);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        )
                      );
                    }
                  }
                }
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Send request to Django and wait for the response
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/create-bookpost-flutter/",
                          jsonEncode(<String, dynamic>{
                            'name': _name,
                            'author': _author,
                            'type': _type,
                            'imagelink': _imagelink,
                            'description': _description,
                            'taggits': _taggits,
                          })
                        );
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                            content: Text("New book suggestion has saved successfully!"),
                          ));
                          Navigator.of(context).pop(true);
                        } else {
                          ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                            content:
                              Text("Something went wrong, please try again."),
                          ));
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text('Back'),
                  )
                )
              ),
            ]
          )
        ),
      ),
    );
  }
}