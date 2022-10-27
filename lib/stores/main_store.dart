import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:target_flutter/helpers/dolarRequest.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/model/target.dart';
import 'package:target_flutter/repository/debit_repository.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

import '../model/user.dart';
import '../repository/target_repository.dart';

part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  _MainStore() {
    reload();
  }

  Future<void> reload() async {
    try {
      try {
        DolarRequest.priceDolar = await DolarRequest.requestDolar();

        print('preço do real em relacao ao dolar: ${DolarRequest.priceDolar}');
      } catch (e) {
        print('erro get dolar: $e');
      }
      print('wait delay');
      await Future.delayed(Duration(seconds: 1));
      print('delay finished');
      User? user = GetIt.I<UserManagerStore>().user;
      if (user != null) {
        print('user Main -> $user');
        print('resetPage');
        resetPage();
        targetList.clear();
        print('setLoading true');
        setLoading(true);
        print('getMainTargetList');
        final newTargets = await TargetRepository().getMainTargetList(user);
        print('addNewTargets');
        await addNewTargets(newTargets);
        print('setError(null)');
        setError(null);
        print('setLoading false');
        setLoading(false);
      } else {
        print('User null main');
      }
    } catch (e) {
      //print('setError(${e.toString()})');
      setError(e.toString());
    }
  }

  ObservableList<Target> targetList = ObservableList<Target>();

  @observable
  bool loading = false;

  @observable
  String? error;

  @observable
  bool lastPage = false;

  @observable
  int page = 0;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setError(String? value) => error = value;

  @action
  Future<void> addNewTargets(List<Target> newTargets) async {
    resetPage();
    print('newTargets size: ${newTargets.length}');
    for (int i = 0; i < newTargets.length; i++) {
      print('add on list: ${newTargets[i].descricao}');

      TypeDebit tipo = newTargets[i].tipoValor;

      newTargets[i].valorAtual = await DebitRepository().getSomeDebitFromTarget(
        newTargets[i], tipo,
      );

      newTargets[i].progress =
          ((newTargets[i].valorAtual! * 100) / newTargets[i].valorFinal!);
    }

    print('size now list target: ${targetList.length}');

    if (targetList.isEmpty) {
      targetList.addAll(newTargets);
    }
  }

  @action
  void loadNextPage() {
    page++;
  }

  @computed
  int get itemCount => targetList.length;

  void resetPage() {
    page = 0;
    targetList.clear();
    lastPage = false;
  }

  @computed
  bool get showProgress => loading && targetList.isEmpty;

  @action
  Future<void> removeTarget(int indice) async {
    print('apertou no delete');
    try {
      loading = true;

      var _target = targetList[indice];

      print('deletando o target $_target');

      TargetRepository().deleteTarget(_target);

      print('removido o target com sucesso');

      targetList.removeAt(indice);

      loading = false;
    } catch (e) {
      print(e);
    }
  }
}
