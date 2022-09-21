import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:target_flutter/repository/target_repository.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

import '../model/target.dart';

part 'add_store.g.dart';

class AddStore = _AddStore with _$AddStore;

abstract class _AddStore with Store {
  @observable
  String descricao = "";

  @observable
  double valorInicial = 0.0;

  @observable
  double valorFinal = 0.0;

  @observable
  String? error;

  @observable
  bool loading = false;

  @observable
  bool saveTarget = false;

  @action
  void setDescricao(String value) => descricao = value;

  @computed
  bool get descricaoValid => descricao.isNotEmpty;

  String? get descricaoError {
    if (descricaoValid) {
      return null;
    } else {
      return 'O campo deve ser preenchido';
    }
  }

  @action
  void setValorInicial(double value) => valorInicial = value;

  @computed
  bool get valorInicialValid => valorInicial > 0;

  @action
  void setValorFinal(double value) => valorFinal = value;

  @computed
  bool get valorFinalValid => valorInicial > 0;

  String? get valorFinalError {
    if (valorFinalValid) {
      return null;
    } else {
      return "Valor final tem que ser maior que zero.";
    }
  }

  @computed
  bool get formValid => descricaoValid && valorFinalValid;

  @computed
  Function() get sendPressed => formValid ? _send : () {};

  @action
  Future<void> _send() async {
    Target _target = Target(
      descricao: descricao,
      valorFinal: valorFinal,
      user: GetIt.I<UserManagerStore>().user,
    );

    loading = true;

    try {
      await TargetRepository().save(_target);
      saveTarget = true;
    } catch (e) {
      error = e.toString();
    }

    loading = false;
  }
}
