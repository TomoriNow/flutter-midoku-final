import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/models/book.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:midoku/screens/login.dart';
import 'package:midoku/screens/add_to_collection_page.dart';
class ViewPage extends StatefulWidget {
    final BookEntry bookEntry;
    const ViewPage({Key? key, required this.bookEntry}) : super(key: key);

    @override
    _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
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
                    book.taggits.toString(),
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
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Status: $_status', // Display the current status here
        style: TextStyle(fontSize: 16.0),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Last Chapter Read: ${_lastChapterController.text}', // Display last chapter read
        style: TextStyle(fontSize: 16.0),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Notes: ${_notesController.text}', // Display notes
        style: TextStyle(fontSize: 16.0),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Review: ${_reviewController.text}', // Display review
        style: TextStyle(fontSize: 16.0),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Rating: ${_ratingController.text}', // Display rating
        style: TextStyle(fontSize: 16.0),
      ),
    ),
  ],
),

              Align(
  alignment: Alignment.bottomCenter,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            // Handle icon button press
            final bool? shouldRefresh = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddtoCollectionPage(bookEntry: book),
              ),
            );
          },
          child: const Text('Add book to Your collection'),
        ),
      ),
    ],
  ),
)

            ]
          )),
          ]
        ),
      ),
      ),
    );
  }
}