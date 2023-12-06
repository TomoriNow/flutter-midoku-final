// To parse this JSON data, do
//
//     final tagpost = tagpostFromJson(jsonString);

import 'dart:convert';

List<Tagpost> tagpostFromJson(String str) => List<Tagpost>.from(json.decode(str).map((x) => Tagpost.fromJson(x)));

String tagpostToJson(List<Tagpost> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tagpost {
    int id;
    String tag;
    int user;

    Tagpost({
        required this.id,
        required this.tag,
        required this.user,
    });

    factory Tagpost.fromJson(Map<String, dynamic> json) => Tagpost(
        id: json["id"],
        tag: json["tag"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tag": tag,
        "user": user,
    };
}
