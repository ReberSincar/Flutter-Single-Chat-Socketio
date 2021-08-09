import 'dart:typed_data';

class Message {
  Message({
    this.senderId,
    this.receiverId,
    this.message,
    this.image,
    this.messageType,
    this.createdAt,
  });

  String? senderId;
  String? receiverId;
  String? message;
  Uint8List? image;
  int? messageType;
  DateTime? createdAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        image: json["image"] != null
            ? Uint8List.fromList(json["image"].cast<int>().toList())
            : null,
        messageType: json["message_type"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "image": image,
        "message_type": messageType,
        "created_at": createdAt.toString(),
      };
}
