// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainStore on _MainStore, Store {
  Computed<int>? _$itemCountComputed;

  @override
  int get itemCount => (_$itemCountComputed ??=
          Computed<int>(() => super.itemCount, name: '_MainStore.itemCount'))
      .value;
  Computed<bool>? _$showProgressComputed;

  @override
  bool get showProgress =>
      (_$showProgressComputed ??= Computed<bool>(() => super.showProgress,
              name: '_MainStore.showProgress'))
          .value;

  late final _$loadingAtom = Atom(name: '_MainStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$errorAtom = Atom(name: '_MainStore.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$lastPageAtom =
      Atom(name: '_MainStore.lastPage', context: context);

  @override
  bool get lastPage {
    _$lastPageAtom.reportRead();
    return super.lastPage;
  }

  @override
  set lastPage(bool value) {
    _$lastPageAtom.reportWrite(value, super.lastPage, () {
      super.lastPage = value;
    });
  }

  late final _$pageAtom = Atom(name: '_MainStore.page', context: context);

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  late final _$addNewTargetsAsyncAction =
      AsyncAction('_MainStore.addNewTargets', context: context);

  @override
  Future<void> addNewTargets(List<Target> newTargets) {
    return _$addNewTargetsAsyncAction
        .run(() => super.addNewTargets(newTargets));
  }

  late final _$removeTargetAsyncAction =
      AsyncAction('_MainStore.removeTarget', context: context);

  @override
  Future<void> removeTarget(int indice) {
    return _$removeTargetAsyncAction.run(() => super.removeTarget(indice));
  }

  late final _$_MainStoreActionController =
      ActionController(name: '_MainStore', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo =
        _$_MainStoreActionController.startAction(name: '_MainStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? value) {
    final _$actionInfo =
        _$_MainStoreActionController.startAction(name: '_MainStore.setError');
    try {
      return super.setError(value);
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadNextPage() {
    final _$actionInfo = _$_MainStoreActionController.startAction(
        name: '_MainStore.loadNextPage');
    try {
      return super.loadNextPage();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
lastPage: ${lastPage},
page: ${page},
itemCount: ${itemCount},
showProgress: ${showProgress}
    ''';
  }
}
