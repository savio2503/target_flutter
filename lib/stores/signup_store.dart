import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:target_flutter/helpers/extensions.dart';
import 'package:target_flutter/repository/user_repository.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

import '../model/user.dart';

part 'signup_store.g.dart';

class SignupStore = _SignupStore with _$SignupStore;

abstract class _SignupStore with Store {
  @observable
  String? name;

  @observable
  String? email;

  @observable
  String? pass1;

  @observable
  String? pass2;

  @action
  void setName(String value) => name = value;

  @computed
  bool get nameValid => name != null && name!.length > 6;

  String? get nameError {
    if (name == null || nameValid) {
      return null;
    } else if (name!.isEmpty) {
      return 'Campo obrigatorio';
    } else {
      return 'Nome muito curto';
    }
  }

  @action
  void setEmail(String value) => email = value;

  @computed
  bool get emailValid => email != null && email!.isEmailValid();

  String? get emailError {
    if (email == null || emailValid)
      return null;
    else if (email!.isEmpty)
      return 'Campo obrigatório';
    else
      return 'E-mail inválido';
  }

  @action
  void setPass1(String value) => pass1 = value;

  @computed
  bool get pass1Valid => pass1 != null && pass1!.length >= 6;
  String? get pass1Error {
    if (pass1 == null || pass1Valid)
      return null;
    else if (pass1!.isEmpty)
      return 'Campo obrigatório';
    else
      return 'Senha muito curta';
  }

  @action
  void setPass2(String value) => pass2 = value;

  @computed
  bool get pass2Valid => pass2 != null && pass2 == pass1;
  String? get pass2Error {
    if (pass2 == null || pass2Valid)
      return null;
    else
      return 'Senhas não coincidem';
  }

  @computed
  bool get isFormValid => nameValid && emailValid && pass1Valid && pass2Valid;

  @computed
  Function() get signUpPressed => (isFormValid && !loading) ? _signUp : () {};

  @observable
  bool loading = false;

  @observable
  String? error;

  @action
  Future<void> _signUp() async {
    loading = true;

    final user = User(user: name!, email: email!, pass: pass1);

    try {
      final resultUser = await UserRepository().signUp(user);
      GetIt.I<UserManagerStore>().setUser(resultUser);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
  }
}
