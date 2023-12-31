// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:midoku/screens/add_catalog_entry.dart';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
    int id;
    List<String> taggits;
    String name;
    String imagelink;
    Type type;
    String author;
    String description;
    String? tags;

    Book({
        required this.id,
        required this.taggits,
        required this.name,
        required this.imagelink,
        required this.type,
        required this.author,
        required this.description,
        required this.tags,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        taggits: List<String>.from(json["taggits"].map((x) => x)),
        name: json["name"],
        imagelink: json["imagelink"],
        type: typeValues.map[json["type"]]!,
        author: json["author"],
        description: json["description"],
        tags: json["tags"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "taggits": List<dynamic>.from(taggits.map((x) => x)),
        "name": name,
        "imagelink": imagelink,
        "type": typeValues.reverse[type],
        "author": author,
        "description": description,
        "tags": tags,
    };
    
    Widget buildCatalogWidget(BuildContext context) {
      return Card(
        surfaceTintColor: Colors.white,
        margin: const EdgeInsets.symmetric(
          horizontal: 4, vertical: 3,
        ),
        elevation: 10,
        child:  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5), // Adjust the opacity as needed
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // You can adjust the offset to control the direction of the glow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Stack(
          children: [
            Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$name ",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "by $author",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (imagelink != "/static/logos.png")
                    Image.network(
                      imagelink, // Replace with your image URL
                      width: 250, // Set the width of the image
                      fit: BoxFit.contain, // BoxFit property to control how the image should be inscribed into the box
                    ),
                  if (imagelink == "/static/logos.png")
                    Image.asset(
                      'assets/logos.png', // Replace with your image path
                      width: 250.0, // Set the width of the image
                      fit: BoxFit.contain, // Adjust the BoxFit as needed
                    ),
                  const Text(
                    "Type:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    typeValues.reverse[type]!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Text(
                    "\nDescription:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Text(
                    "\nTags:",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    taggits.join(", "),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Handle icon button press
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) =>
                    AddCatalogPage(book: this),
                  ),
                );
              },
            ),
          ),
          ]
        ),
        ),
      );
    }
}

enum Type {
    MANGA,
    MANHWA,
    NOVEL
}

final typeValues = EnumValues({
    "Manga": Type.MANGA,
    "Manhwa": Type.MANHWA,
    "Novel": Type.NOVEL
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
