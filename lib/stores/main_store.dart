import 'package:mobx/mobx.dart';
import 'package:target_flutter/model/target.dart';

import '../repository/target_repository.dart';

part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  _MainStore() {
    autorun((_) async {
      try {
        setLoading(true);
        final newTargets =
            await TargetRepository().getMainTargetList(page: page);
        addNewTargets(newTargets);
        setError(null);
        setLoading(false);
      } catch (e) {
        setError(e.toString());
      }
    });
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
  void addNewTargets(List<Target> newTargets) {
    if (newTargets.length < 10) lastPage = true;
    targetList.addAll(newTargets);
    print('addNewTargets: ${targetList.toString()}');
  }

  @action
  void loadNextPage() {
    page++;
  }

  @computed
  int get itemCount => lastPage ? targetList.length : targetList.length + 1;

  void resetPage() {
    page = 0;
    targetList.clear();
    lastPage = false;
  }

  @computed
  bool get showProgress => loading && targetList.isEmpty;
}
