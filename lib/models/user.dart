class User {
  User({
    this.id,
    this.name,
    this.surname,
  });

  String? id;
  String? name;
  String? surname;
  List messages = [];

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        surname: json["surname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "surname": surname,
      };
}
