import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:target/app/data/models/user_login_request.dart';
import 'package:target/app/data/services/auth/service..dart';
import 'package:target/app/data/services/storage/service.dart';
import 'package:target/app/tools/functions.dart';

class LoginController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _storageService = Get.find<StorageService>();
  var emailController = TextEditingController(text: 'user@mail.com');
  var passwordController = TextEditingController(text: '123456');
  var repassController = TextEditingController();
  var statenum = 0.obs;
  var statestr = "Login".obs;

  LoginController() {
    printd("token: ${_storageService.token}");
    if (_storageService.token == null || _storageService.token!.isEmpty) {
      setLogin();
    } else {
      setLogged();
    }
  }

  void setLogin() {
    printd("setLogin");
    _setStateNum(0);
    _setStateStr("Login");
  }

  void setSignup() {
    printd("setSignup");
    _setStateNum(1);
    _setStateStr("Sign Up");
  }

  void setLogged() {
    printd("setLogged");
    _setStateNum(2);
    _setStateStr("Logado");
  }

  void _setStateNum(int value) => statenum.value = value;

  void _setStateStr(String value) => statestr.value = value;

  void login() async {
    //printd("in login controller");
    var userLoginRequestMode = UserLoginRequestModel(
      email: emailController.text,
      password: passwordController.text,
    );

    await _authService.login(userLoginRequestMode).then((value) => null);

    //printd("out login controller");
    if (_authService.isLogged) {
      Get.back();
    }
  }

  void logout() async {
    await _authService.logout();

    if (!_authService.isLogged) {
      Get.back();
    }
  }
}
