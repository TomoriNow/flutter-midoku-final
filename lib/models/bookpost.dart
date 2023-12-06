// To parse this JSON data, do
//
//     final bookpost = bookpostFromJson(jsonString);

import 'dart:convert';

List<Bookpost> bookpostFromJson(String str) => List<Bookpost>.from(json.decode(str).map((x) => Bookpost.fromJson(x)));

String bookpostToJson(List<Bookpost> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bookpost {
    int id;
    List<String> taggits;
    String name;
    String imagelink;
    String type;
    String author;
    String description;
    int user;

    Bookpost({
        required this.id,
        required this.taggits,
        required this.name,
        required this.imagelink,
        required this.type,
        required this.author,
        required this.description,
        required this.user,
    });

    factory Bookpost.fromJson(Map<String, dynamic> json) => Bookpost(
        id: json["id"],
        taggits: List<String>.from(json["taggits"].map((x) => x)),
        name: json["name"],
        imagelink: json["imagelink"],
        type: json["type"],
        author: json["author"],
        description: json["description"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "taggits": List<dynamic>.from(taggits.map((x) => x)),
        "name": name,
        "imagelink": imagelink,
        "type": type,
        "author": author,
        "description": description,
        "user": user,
    };
}