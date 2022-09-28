import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:target_flutter/model/user.dart';
import 'package:target_flutter/repository/user_repository.dart';
import 'package:target_flutter/stores/main_store.dart';

part 'user_manager_store.g.dart';

class UserManagerStore = _UserManagerStore with _$UserManagerStore;

abstract class _UserManagerStore with Store {
  _UserManagerStore() {
    _getCurrentUser();
  }

  @observable
  User? user;

  @action
  void setUser(User? value) => user = value;

  @observable
  bool isLoading = false;

  @computed
  bool get isLoggedIn => user != null;

  Future<void> _getCurrentUser() async {
    print('-> getCurrentUser');
    isLoading = true;
    final user = await UserRepository().currentUser();
    setUser(user);
    isLoading = false;
    print('<- getCurrentUser');
  }

  Future<void> logout() async {
    await UserRepository().logout();
    setUser(null);
    GetIt.I<MainStore>().targetList.clear();
  }
}
