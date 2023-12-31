import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/models/book_entry.dart';
class AddtoCollectionPage extends StatefulWidget {
    final CustomEntry bookEntry;
    const AddtoCollectionPage({Key? key, required this.bookEntry}) : super(key: key);

    @override
    _AddtoCollectionPage createState() => _AddtoCollectionPage();
}

class _AddtoCollectionPage extends State<AddtoCollectionPage> {
  final _formKey = GlobalKey<FormState>();
  int _lastChapterRead = 0;
  String _review = "";
  int _rating = 0;
  String _notes = ""; 
  String? _status; 
  
  List<String> statuses = ["Plan to read", "Reading", "On Hold", "Dropped", "Finished"];



  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Catalog Entry Form',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Row(
          children: [
            // Info side
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${widget.bookEntry.name} ",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "by ${widget.bookEntry.author}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    widget.bookEntry.imagelink, // Replace with your image URL
                    width: 250, // Set the width of the image // Set the height of the image
                    fit: BoxFit.contain, // BoxFit property to control how the image should be inscribed into the box
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/logos.png',
                          width: 200.0,
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
                    widget.bookEntry.type,
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
                    widget.bookEntry.description,
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
                    widget.bookEntry.taggits.join(", "),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    hintText: "Status",
                    labelText: "Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _status = value;
                    });
                  },
                  items: statuses.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value[0],
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Entry status cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Last Chapter Read",
                    labelText: "Last Chapter Read",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _lastChapterRead = int.parse(value!);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Last Chapter Read cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Last Chapter Read must be a number!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Notes",
                    labelText: "Notes",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _notes = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Notes cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Review",
                    labelText: "Review",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _review = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Review cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Rating",
                    labelText: "Rating",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _rating = int.parse(value!);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Rating cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Rating must be a number!";
                    }
                    if(int.parse(value) > 10 || int.parse(value) < 0) {
                      return "Rating must be between 0 and 10";
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
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Send request to Django and wait for the response
                        final response = await request.postJson(
                          "https://galihsopod.pythonanywhere.com/create-catalog-flutter/",
                          jsonEncode(<String, dynamic>{
                            'id': widget.bookEntry.id,
                            'status': _status,
                            'lastChapterRead' : _lastChapterRead,
                            'notes': _notes,
                            'review': _review,
                            'rating': _rating
                          })
                        );
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                            content: Text("New product has saved successfully!"),
                          ));
                          Navigator.pop(context);
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
          )),
          ]
        ),
      ),
      ),
    );
  }
}