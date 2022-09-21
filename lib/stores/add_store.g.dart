// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddStore on _AddStore, Store {
  Computed<bool>? _$descricaoValidComputed;

  @override
  bool get descricaoValid =>
      (_$descricaoValidComputed ??= Computed<bool>(() => super.descricaoValid,
              name: '_AddStore.descricaoValid'))
          .value;
  Computed<bool>? _$valorInicialValidComputed;

  @override
  bool get valorInicialValid => (_$valorInicialValidComputed ??= Computed<bool>(
          () => super.valorInicialValid,
          name: '_AddStore.valorInicialValid'))
      .value;
  Computed<bool>? _$valorFinalValidComputed;

  @override
  bool get valorFinalValid =>
      (_$valorFinalValidComputed ??= Computed<bool>(() => super.valorFinalValid,
              name: '_AddStore.valorFinalValid'))
          .value;
  Computed<bool>? _$formValidComputed;

  @override
  bool get formValid => (_$formValidComputed ??=
          Computed<bool>(() => super.formValid, name: '_AddStore.formValid'))
      .value;
  Computed<dynamic Function()>? _$sendPressedComputed;

  @override
  dynamic Function() get sendPressed => (_$sendPressedComputed ??=
          Computed<dynamic Function()>(() => super.sendPressed,
              name: '_AddStore.sendPressed'))
      .value;

  late final _$descricaoAtom =
      Atom(name: '_AddStore.descricao', context: context);

  @override
  String get descricao {
    _$descricaoAtom.reportRead();
    return super.descricao;
  }

  @override
  set descricao(String value) {
    _$descricaoAtom.reportWrite(value, super.descricao, () {
      super.descricao = value;
    });
  }

  late final _$valorInicialAtom =
      Atom(name: '_AddStore.valorInicial', context: context);

  @override
  double get valorInicial {
    _$valorInicialAtom.reportRead();
    return super.valorInicial;
  }

  @override
  set valorInicial(double value) {
    _$valorInicialAtom.reportWrite(value, super.valorInicial, () {
      super.valorInicial = value;
    });
  }

  late final _$valorFinalAtom =
      Atom(name: '_AddStore.valorFinal', context: context);

  @override
  double get valorFinal {
    _$valorFinalAtom.reportRead();
    return super.valorFinal;
  }

  @override
  set valorFinal(double value) {
    _$valorFinalAtom.reportWrite(value, super.valorFinal, () {
      super.valorFinal = value;
    });
  }

  late final _$errorAtom = Atom(name: '_AddStore.error', context: context);

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

  late final _$loadingAtom = Atom(name: '_AddStore.loading', context: context);

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

  late final _$saveTargetAtom =
      Atom(name: '_AddStore.saveTarget', context: context);

  @override
  bool get saveTarget {
    _$saveTargetAtom.reportRead();
    return super.saveTarget;
  }

  @override
  set saveTarget(bool value) {
    _$saveTargetAtom.reportWrite(value, super.saveTarget, () {
      super.saveTarget = value;
    });
  }

  late final _$_sendAsyncAction =
      AsyncAction('_AddStore._send', context: context);

  @override
  Future<void> _send() {
    return _$_sendAsyncAction.run(() => super._send());
  }

  late final _$_AddStoreActionController =
      ActionController(name: '_AddStore', context: context);

  @override
  void setDescricao(String value) {
    final _$actionInfo =
        _$_AddStoreActionController.startAction(name: '_AddStore.setDescricao');
    try {
      return super.setDescricao(value);
    } finally {
      _$_AddStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setValorInicial(double value) {
    final _$actionInfo = _$_AddStoreActionController.startAction(
        name: '_AddStore.setValorInicial');
    try {
      return super.setValorInicial(value);
    } finally {
      _$_AddStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setValorFinal(double value) {
    final _$actionInfo = _$_AddStoreActionController.startAction(
        name: '_AddStore.setValorFinal');
    try {
      return super.setValorFinal(value);
    } finally {
      _$_AddStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
descricao: ${descricao},
valorInicial: ${valorInicial},
valorFinal: ${valorFinal},
error: ${error},
loading: ${loading},
saveTarget: ${saveTarget},
descricaoValid: ${descricaoValid},
valorInicialValid: ${valorInicialValid},
valorFinalValid: ${valorFinalValid},
formValid: ${formValid},
sendPressed: ${sendPressed}
    ''';
  }
}
