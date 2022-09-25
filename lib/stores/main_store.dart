import 'package:mobx/mobx.dart';
import 'package:target_flutter/model/target.dart';
import 'package:target_flutter/repository/debit_repository.dart';

import '../repository/target_repository.dart';

part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  _MainStore() {
    autorun((_) async {
      await reload();
    });
  }

  reload() async {
    try {
      print('resetPage');
      resetPage();
      print('setLoading true');
      setLoading(true);
      print('getMainTargetList');
      final newTargets = await TargetRepository().getMainTargetList();
      print('addNewTargets');
      await addNewTargets(newTargets);
      print('setError(null)');
      setError(null);
      print('setLoading false');
      setLoading(false);
    } catch (e) {
      print('setError(${e.toString()})');
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
    for (var localTarget in newTargets) {
      print('add on list: ${localTarget.descricao}');
      localTarget.valorAtual =
          await DebitRepository().getSomeDebitFromTarget(localTarget);

      localTarget.progress =
          ((localTarget.valorAtual! * 100) / localTarget.valorFinal!);

      targetList.add(localTarget);
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
}
