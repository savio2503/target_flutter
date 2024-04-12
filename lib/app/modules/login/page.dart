import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:target/app/modules/login/controller.dart';
import 'package:target/app/modules/login/widgets/logged.dart';
import 'package:target/app/modules/login/widgets/login.dart';
import 'package:target/app/modules/login/widgets/signup.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.statestr.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white,),
      ),
      body: Obx(
        () => Column(
          children: [
            if (controller.statenum.value == 0) Login(controller),
            if (controller.statenum.value == 1) SignUp(controller),
            if (controller.statenum.value == 2) Logged(controller),
          ],
        ),
      ),
    );
  }
}
