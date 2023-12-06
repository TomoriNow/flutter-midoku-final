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

    return 
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:  ListView(
                  children: [
                    Text(
                      book.name,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.network(
                      book.imagelink,
                      width: 250,
                      height: 300,
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
                    const SizedBox(height: 10),
                    Text(
                      "Rating: ${widget.bookEntry.rating}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
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