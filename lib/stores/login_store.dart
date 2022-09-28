import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:target_flutter/helpers/extensions.dart';
import 'package:target_flutter/repository/user_repository.dart';

import '../screens/main/main_screen.dart';
import 'user_manager_store.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  String? email;

  @action
  void setEmail(String value) => email = value;

  @computed
  bool get emailValid => email != null && email!.isEmailValid();

  String? get emailError =>
      email == null || emailValid ? null : 'E-mail invalido';

  @observable
  String? password;

  @action
  void setPassword(String value) => password = value;

  @computed
  bool get passwordValid => password != null && password!.length >= 4;

  String? get passwordError =>
      password == null || passwordValid ? null : 'Senha invalida';

  @computed
  Function() get loginPressed =>
      emailValid && passwordValid && !loading ? _login : () {};

  @observable
  BuildContext? _context;

  @action
  void setContext(BuildContext value) => _context = value;

  @observable
  bool loading = false;

  @observable
  String? error;

  @action
  Future<void> _login() async {
    loading = true;

    try {
      final user = await UserRepository().loginWithEmail(email!, password!);
      print('user _login: $user');
      GetIt.I<UserManagerStore>().setUser(user);
      print('usuario logado: ${user.user}');
      Navigator.push(
        _context!,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      error = e.toString();
    }

    loading = false;
  }
}
