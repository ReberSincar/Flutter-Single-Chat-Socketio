import 'package:flutter_private_chat/models/user.dart';
import 'package:flutter_private_chat/screens/connect_screen.dart';
import 'package:flutter_private_chat/services/db_services.dart';
import 'package:flutter_private_chat/services/socket_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SplashController extends GetxController {
  DBService dbService = Get.find();
  SocketService socketService = Get.find();

  @override
  onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    User? dbUser = dbService.getUser();
    if (dbUser != null) {
      socketService.connectSocket(dbUser);
    } else {
      Get.to(() => ConnectScreen());
    }
    super.onReady();
  }
}
