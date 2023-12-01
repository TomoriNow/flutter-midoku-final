// To parse this JSON data, do
//
//     final tag = tagFromJson(jsonString);

import 'dart:convert';

List<Tag> tagFromJson(String str) => List<Tag>.from(json.decode(str).map((x) => Tag.fromJson(x)));

String tagToJson(List<Tag> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tag {
    Model model;
    int pk;
    Fields fields;

    Tag({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    String slug;

    Fields({
        required this.name,
        required this.slug,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        slug: json["slug"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
    };
}

enum Model {
    TAGGIT_TAG
}

final modelValues = EnumValues({
    "taggit.tag": Model.TAGGIT_TAG
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
