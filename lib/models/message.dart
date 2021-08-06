class Message {
  Message({
    this.senderId,
    this.receiverId,
    this.message,
    this.messageType,
    this.createdAt,
  });

  String? senderId;
  String? receiverId;
  String? message;
  int? messageType;
  DateTime? createdAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        messageType: json["message_type"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "message_type": messageType,
        "created_at": createdAt.toString(),
      };
}
