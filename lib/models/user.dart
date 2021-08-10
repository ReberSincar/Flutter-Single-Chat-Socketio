import 'message.dart';

class User {
  User({
    this.id,
    this.name,
    this.surname,
    this.isOnline,
    this.messages,
  });

  String? id;
  String? name;
  String? surname;
  bool? isOnline;
  bool isTyping = false;
  List? messages;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
        isOnline: json["isOnline"],
        messages: json["messages"] != null
            ? json["messages"].map((e) => Message.fromJson(e)).toList()
            : [],
      );

  Map<String, dynamic> toJsonForConnect() => {
        "id": id,
        "name": name,
        "surname": surname,
      };

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
        "isOnline": isOnline,
        "messages":
            messages != null ? messages!.map((e) => e.toJson()).toList() : [],
      };

  toJsonMessages() =>
      messages != null ? messages!.map((e) => e.toJson()).toList() : [];
}
