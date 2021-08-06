import 'package:flutter/material.dart';
import 'package:flutter_private_chat/controllers/splash_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Color(0xFFf2f2f2),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.teal,
        ),
      ),
    );
  }
}
