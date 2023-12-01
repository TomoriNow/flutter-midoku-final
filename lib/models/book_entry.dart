// To parse this JSON data, do
//
//     final bookEntry = bookEntryFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<BookEntry> bookEntryFromJson(String str) => List<BookEntry>.from(json.decode(str).map((x) => BookEntry.fromJson(x)));

String bookEntryToJson(List<BookEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookEntry {
    String status;
    int lastChapterRead;
    CatalogEntry? catalogEntry;
    DateTime lastReadDate;
    CustomEntry? customEntry;
    String review;
    int rating;
    int pk;
    String notes;

    BookEntry({
        required this.status,
        required this.lastChapterRead,
        required this.catalogEntry,
        required this.lastReadDate,
        required this.customEntry,
        required this.review,
        required this.rating,
        required this.pk,
        required this.notes,
    });

    factory BookEntry.fromJson(Map<String, dynamic> json) => BookEntry(
        status: json["status"],
        lastChapterRead: json["last_chapter_read"],
        catalogEntry: json["catalog_entry"] == null ? null : CatalogEntry.fromJson(json["catalog_entry"]),
        lastReadDate: DateTime.parse(json["last_read_date"]),
        customEntry: json["custom_entry"] == null ? null : CustomEntry.fromJson(json["custom_entry"]),
        review: json["review"],
        rating: json["rating"],
        pk: json["pk"],
        notes: json["notes"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "last_chapter_read": lastChapterRead,
        "catalog_entry": catalogEntry?.toJson(),
        "last_read_date": "${lastReadDate.year.toString().padLeft(4, '0')}-${lastReadDate.month.toString().padLeft(2, '0')}-${lastReadDate.day.toString().padLeft(2, '0')}",
        "custom_entry": customEntry?.toJson(),
        "review": review,
        "rating": rating,
        "pk": pk,
        "notes": notes,
    };

    Widget buildEntryWidget() {
      CustomEntry book = customEntry ?? catalogEntry!.book;
      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12
        ),
        elevation: 10,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 600,
              child: ListView(
                children: [
                  Text(
                    book.name,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.network(
                    book.imagelink, // Replace with your image URL
                    width: 250, // Set the width of the image
                    height: 400, // Set the height of the image
                    fit: BoxFit.contain, // BoxFit property to control how the image should be inscribed into the box
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Rating: $rating",
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
          ),
        ),
      );
    }
}

class CatalogEntry {
    CustomEntry book;

    CatalogEntry({
        required this.book,
    });

    factory CatalogEntry.fromJson(Map<String, dynamic> json) => CatalogEntry(
        book: CustomEntry.fromJson(json["book"]),
    );

    Map<String, dynamic> toJson() => {
        "book": book.toJson(),
    };
}

class CustomEntry {
    int? id;
    List<String> taggits;
    String name;
    String imagelink;
    String type;
    String author;
    String description;
    String? tags;
    int? entry;

    CustomEntry({
        this.id,
        required this.taggits,
        required this.name,
        required this.imagelink,
        required this.type,
        required this.author,
        required this.description,
        this.tags,
        this.entry,
    });

    factory CustomEntry.fromJson(Map<String, dynamic> json) => CustomEntry(
        id: json["id"],
        taggits: List<String>.from(json["taggits"].map((x) => x)),
        name: json["name"],
        imagelink: json["imagelink"],
        type: json["type"],
        author: json["author"],
        description: json["description"],
        tags: json["tags"],
        entry: json["entry"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "taggits": List<dynamic>.from(taggits.map((x) => x)),
        "name": name,
        "imagelink": imagelink,
        "type": type,
        "author": author,
        "description": description,
        "tags": tags,
        "entry": entry,
    };
}