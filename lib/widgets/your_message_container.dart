import 'package:flutter/material.dart';
import 'package:flutter_private_chat/models/message.dart';

class YourMessageContainer extends StatelessWidget {
  const YourMessageContainer({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Text(
          message.message!,
          style: TextStyle(
            color: Colors.teal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
