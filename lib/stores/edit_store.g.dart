// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditStore on _EditStore, Store {
  Computed<bool>? _$descricaoValidComputed;

  @override
  bool get descricaoValid =>
      (_$descricaoValidComputed ??= Computed<bool>(() => super.descricaoValid,
              name: '_EditStore.descricaoValid'))
          .value;
  Computed<bool>? _$finalValidComputed;

  @override
  bool get finalValid => (_$finalValidComputed ??=
          Computed<bool>(() => super.finalValid, name: '_EditStore.finalValid'))
      .value;
  Computed<bool>? _$valorDepositarValidComputed;

  @override
  bool get valorDepositarValid => (_$valorDepositarValidComputed ??=
          Computed<bool>(() => super.valorDepositarValid,
              name: '_EditStore.valorDepositarValid'))
      .value;

  late final _$descricaoAtom =
      Atom(name: '_EditStore.descricao', context: context);

  @override
  String? get descricao {
    _$descricaoAtom.reportRead();
    return super.descricao;
  }

  @override
  set descricao(String? value) {
    _$descricaoAtom.reportWrite(value, super.descricao, () {
      super.descricao = value;
    });
  }

  late final _$valorFinalAtom =
      Atom(name: '_EditStore.valorFinal', context: context);

  @override
  num? get valorFinal {
    _$valorFinalAtom.reportRead();
    return super.valorFinal;
  }

  @override
  set valorFinal(num? value) {
    _$valorFinalAtom.reportWrite(value, super.valorFinal, () {
      super.valorFinal = value;
    });
  }

  late final _$loadingAtom = Atom(name: '_EditStore.loading', context: context);

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

  late final _$valorADepositarAtom =
      Atom(name: '_EditStore.valorADepositar', context: context);

  @override
  num? get valorADepositar {
    _$valorADepositarAtom.reportRead();
    return super.valorADepositar;
  }

  @override
  set valorADepositar(num? value) {
    _$valorADepositarAtom.reportWrite(value, super.valorADepositar, () {
      super.valorADepositar = value;
    });
  }

  late final _$editAtom = Atom(name: '_EditStore.edit', context: context);

  @override
  bool get edit {
    _$editAtom.reportRead();
    return super.edit;
  }

  @override
  set edit(bool value) {
    _$editAtom.reportWrite(value, super.edit, () {
      super.edit = value;
    });
  }

  late final _$tipoDepositoAtom =
      Atom(name: '_EditStore.tipoDeposito', context: context);

  @override
  TypeDebit get tipoDeposito {
    _$tipoDepositoAtom.reportRead();
    return super.tipoDeposito;
  }

  @override
  set tipoDeposito(TypeDebit value) {
    _$tipoDepositoAtom.reportWrite(value, super.tipoDeposito, () {
      super.tipoDeposito = value;
    });
  }

  late final _$setTargetAsyncAction =
      AsyncAction('_EditStore.setTarget', context: context);

  @override
  Future<void> setTarget(Target target) {
    return _$setTargetAsyncAction.run(() => super.setTarget(target));
  }

  late final _$reloadDebitAsyncAction =
      AsyncAction('_EditStore.reloadDebit', context: context);

  @override
  Future<void> reloadDebit(Target target) {
    return _$reloadDebitAsyncAction.run(() => super.reloadDebit(target));
  }

  late final _$removeDebitAsyncAction =
      AsyncAction('_EditStore.removeDebit', context: context);

  @override
  Future<void> removeDebit(int indice) {
    return _$removeDebitAsyncAction.run(() => super.removeDebit(indice));
  }

  late final _$_EditStoreActionController =
      ActionController(name: '_EditStore', context: context);

  @override
  void setTipoDeposito(TypeDebit value) {
    final _$actionInfo = _$_EditStoreActionController.startAction(
        name: '_EditStore.setTipoDeposito');
    try {
      return super.setTipoDeposito(value);
    } finally {
      _$_EditStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescricao(String? value) {
    final _$actionInfo = _$_EditStoreActionController.startAction(
        name: '_EditStore.setDescricao');
    try {
      return super.setDescricao(value);
    } finally {
      _$_EditStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFinal(num? value) {
    final _$actionInfo =
        _$_EditStoreActionController.startAction(name: '_EditStore.setFinal');
    try {
      return super.setFinal(value);
    } finally {
      _$_EditStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDebit(Debit debit) {
    final _$actionInfo =
        _$_EditStoreActionController.startAction(name: '_EditStore.setDebit');
    try {
      return super.setDebit(debit);
    } finally {
      _$_EditStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setValorDepositar(num? value) {
    final _$actionInfo = _$_EditStoreActionController.startAction(
        name: '_EditStore.setValorDepositar');
    try {
      return super.setValorDepositar(value);
    } finally {
      _$_EditStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
descricao: ${descricao},
valorFinal: ${valorFinal},
loading: ${loading},
valorADepositar: ${valorADepositar},
edit: ${edit},
tipoDeposito: ${tipoDeposito},
descricaoValid: ${descricaoValid},
finalValid: ${finalValid},
valorDepositarValid: ${valorDepositarValid}
    ''';
  }
}
