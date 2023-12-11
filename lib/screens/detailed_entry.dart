import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/models/book.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DetailEntryPage extends StatefulWidget {
    final BookEntry bookEntry;
    const DetailEntryPage({Key? key, required this.bookEntry}) : super(key: key);

    @override
    _DetailEntryPageState createState() => _DetailEntryPageState();
}

class _DetailEntryPageState extends State<DetailEntryPage> {
  final _formKey = GlobalKey<FormState>();
  String? _status; 
  TextEditingController _lastChapterController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _reviewController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lastChapterController.text = widget.bookEntry.lastChapterRead.toString();
    _notesController.text = widget.bookEntry.notes;
    _reviewController.text = widget.bookEntry.review;
    _ratingController.text = widget.bookEntry.rating.toString();
  }
  
  List<String> statuses = ["Plan to read", "Reading", "On Hold", "Dropped", "Finished"];



  @override
  Widget build(BuildContext context) {
    _status = widget.bookEntry.status;
    CustomEntry book = widget.bookEntry.customEntry ?? widget.bookEntry.catalogEntry!.book;
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Detailed Entry Page',
          ),
        ),
        backgroundColor: Colors.amberAccent,
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
                          text: "${book.name} ",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "by ${book.author}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            // Add other styling properties for the author
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    book.imagelink, // Replace with your image URL
                    width: 250, // Set the width of the image 
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
                    book.type,
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
                    book.description,
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
                    book.taggits.join(", "),
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
              Text(
                    "Last Edit Date: ${widget.bookEntry.lastReadDate}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  controller: _lastChapterController,
                  decoration: InputDecoration(
                    hintText: "Last Chapter Read",
                    labelText: "Last Chapter Read",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
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
                  controller: _notesController,
                  decoration: InputDecoration(
                    hintText: "Notes",
                    labelText: "Notes",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
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
                  controller: _reviewController,
                  decoration: InputDecoration(
                    hintText: "Review",
                    labelText: "Review",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
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
                  controller: _ratingController,
                  decoration: InputDecoration(
                    hintText: "Rating",
                    labelText: "Rating",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
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
                        widget.bookEntry.rating = int.parse(_ratingController.text);
                        // Send request to Django and wait for the response
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/edit-entry-flutter/",
                          jsonEncode(<String, dynamic>{
                            'id': widget.bookEntry.pk,
                            'status': _status,
                            'lastChapterRead' : _lastChapterController.text,
                            'notes': _notesController.text,
                            'review': _reviewController.text,
                            'rating': _ratingController.text
                          })
                        );
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                            content: Text("Changes saved successfully!"),
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
          )),
          ]
        ),
      ),
      ),
    );
  }
}