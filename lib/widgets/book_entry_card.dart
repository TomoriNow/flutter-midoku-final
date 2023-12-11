import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:midoku/models/book_entry.dart';
import 'package:midoku/screens/detailed_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookEntryCard extends StatefulWidget {
  final BookEntry bookEntry;

  const BookEntryCard({Key? key, required this.bookEntry}) : super(key: key);

  @override
  _BookEntryCardState createState() => _BookEntryCardState();
}

class _BookEntryCardState extends State<BookEntryCard> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    CustomEntry book = widget.bookEntry.customEntry ?? widget.bookEntry.catalogEntry!.book;
    String status;
    if (widget.bookEntry.status == "P") {status = "Plan to Read";}
    else if (widget.bookEntry.status == "R") {status = "Reading";}
    else if (widget.bookEntry.status == "O") {status = "On Hold";}
    else if (widget.bookEntry.status == "F") {status = "Finished";}
    else {status = "Dropped";}

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child:  ListView(
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
              Image.network(
                book.imagelink,
                width: 250,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/logos.png',
                    width: 200.0,
                    fit: BoxFit.contain,
                  );
                },
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Status:",
                        style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        status,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ]
                  ), 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Rating:",
                        style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.bookEntry.rating.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ]
                  ),
                ]
              ),
              const SizedBox(height: 4),
              Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Last Chapter Read: ${widget.bookEntry.lastChapterRead}",
                        style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ),
              const SizedBox(height: 4),
              const Text(
                "Description:",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                book.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
      ),
    );      
  }
}