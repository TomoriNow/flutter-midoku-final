// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

List<Profile> profileFromJson(String str) => List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Profile {
    int id;
    int user;
    int favourite;

    Profile({
        required this.id,
        required this.user,
        required this.favourite,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        user: json["user"],
        favourite: json["favourite"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "favourite": favourite,
    };
}
