import 'package:flutter/material.dart';
import 'package:flutter_private_chat/controllers/chat_controller.dart';
import 'package:flutter_private_chat/screens/connect_screen.dart';
import 'package:flutter_private_chat/screens/splash_screen.dart';
import 'package:flutter_private_chat/services/db_services.dart';
import 'package:flutter_private_chat/services/socket_service.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  Get.put(DBService());
  Get.put(SocketService());
  Get.put(ChatController());
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
