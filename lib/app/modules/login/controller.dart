import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:target/app/data/models/user_login_request.dart';
import 'package:target/app/data/services/auth/auth_service..dart';
import 'package:target/app/data/services/coin/service.dart';
import 'package:target/app/data/services/storage/storage_service.dart';
import 'package:target/app/tools/functions.dart';

class LoginController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _storageService = Get.find<StorageService>();
  var emailController = TextEditingController(text: 'user@mail.com');
  var passwordController = TextEditingController(text: '123456');
  var repassController = TextEditingController();
  var statenum = 0.obs;
  var statestr = "Login".obs;
  var error = "".obs;

  LoginController() {

    if (_storageService.token == null || _storageService.token!.isEmpty) {
      setLogin();
    } else {
      setLogged();
    }
  }

  void setLogin() {
    _setStateNum(0);
    _setStateStr("Login");
  }

  void setSignup() {
    _setStateNum(1);
    _setStateStr("Sign Up");
  }

  void setLogged() {
    _setStateNum(2);
    _setStateStr("Logado");
  }

  void _setStateNum(int value) => statenum.value = value;

  void _setStateStr(String value) => statestr.value = value;

  Future<bool> login() async {

    var result = false;

    var userLoginRequestMode = UserLoginRequestModel(
      email: emailController.text,
      password: passwordController.text,
    );

    try {
      await _authService.login(userLoginRequestMode);
    } catch (e) {
      error.value = e.toString();
    }

    if (_authService.isLogged) {
      await Get.find<CoinService>().getCoins();
      Get.back();
    }

    return result;
  }

  void logout() async {
    await _authService.logout();

    if (!_authService.isLogged) {
      Get.back();
    }
  }
}
