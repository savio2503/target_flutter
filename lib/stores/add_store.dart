import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/repository/target_repository.dart';
import 'package:target_flutter/stores/debit_store.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

import '../model/target.dart';
import 'main_store.dart';

part 'add_store.g.dart';

class AddStore = _AddStore with _$AddStore;

abstract class _AddStore with Store {
  @observable
  String descricao = "";

  @observable
  double valorInicial = 0.0;

  @observable
  TypeDebit tipoInicial = TypeDebit.REAL;

  @action
  void setTipoInicial(TypeDebit value) => tipoInicial = value;

  @observable
  double valorFinal = 0.0;

  @observable
  TypeDebit tipoFinal = TypeDebit.REAL;

  @action
  void setTipoFinal(TypeDebit value) => tipoFinal = value;

  @observable
  String? error;

  @observable
  bool loading = false;

  @observable
  bool saveTarget = false;

  @observable
  BuildContext? _context;

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
  bool get valorInicialValid => valorInicial >= 0;

  @action
  void setValorFinal(double value) => valorFinal = value;

  @computed
  bool get valorFinalValid => valorFinal > 0;
  String? get valorFinalError {
    if (valorFinalValid) {
      return null;
    } else {
      return "Valor final tem que ser maior que zero.";
    }
  }

  @computed
  bool get formValid => descricaoValid && valorFinalValid;

  @action
  void setContext(BuildContext value) => _context = value;

  @computed
  Function() get sendPressed => formValid ? _send : () {};

  @action
  Future<void> _send() async {
    print('chamou o _send');
    Target _target = Target(
      descricao: descricao,
      valorFinal: valorFinal,
      user: GetIt.I<UserManagerStore>().user,
      tipoValor: tipoFinal,
    );

    loading = true;

    try {
      print('enviando o target');

      Target targetResult = await TargetRepository().save(_target);
      targetResult.user = _target.user;

      print('targetResult: $targetResult');

      if (valorInicial > 0.0) {
        await DebitStore().saveDebit(targetResult, valorInicial, tipoInicial);
      }
      saveTarget = true;
      await GetIt.I<MainStore>().reload();
      Navigator.of(_context!).pop();
    } catch (e) {
      error = e.toString();
    }

    loading = false;
  }
}
