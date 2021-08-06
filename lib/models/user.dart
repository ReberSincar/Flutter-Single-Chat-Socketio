import 'message.dart';

class User {
  User({
    this.id,
    this.name,
    this.surname,
    this.messages,
  });

  String? id;
  String? name;
  String? surname;
  List? messages;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        messages: json["messages"] != null
            ? json["messages"].map((e) => Message.fromJson(e)).toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "messages":
            messages != null ? messages!.map((e) => e.toJson()).toList() : [],
      };
}
