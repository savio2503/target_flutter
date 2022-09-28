import 'package:mobx/mobx.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/model/target.dart';
import 'package:target_flutter/stores/debit_store.dart';

part 'edit_store.g.dart';

class EditStore = _EditStore with _$EditStore;

abstract class _EditStore with Store {
  @observable
  String? descricao;

  @observable
  num? valorFinal;

  String idTarget = "";

  @observable
  bool loading = false;

  @observable
  num? valorADepositar;

  ObservableList<Debit> debitList = ObservableList<Debit>();

  @action
  Future<void> setTarget(Target target) async {
    descricao = target.descricao!;
    print('setTarget: ${target.valorFinal}');
    valorFinal = target.valorFinal;
    idTarget = target.id!;

    reloadDebit(target);
  }

  @action
  Future<void> reloadDebit(Target target) async {
    debitList.clear();

    final _debits = await DebitStore().getAllDebit(target);

    debitList.addAll(_debits);
  }

  @action
  void setDescricao(String? value) => descricao = value;

  @computed
  bool get descricaoValid => descricao != null && descricao!.isNotEmpty;
  String? get descricaoError {
    if (descricaoValid) {
      return null;
    } else {
      return 'A descrição não pode ficar vazia!';
    }
  }

  @action
  void setFinal(num? value) => valorFinal = value;

  @computed
  bool get finalValid => valorFinal != null && valorFinal! > 0;
  String? get finalError {
    if (finalValid) {
      return null;
    } else {
      return 'O valor final tem que ser maior que zero';
    }
  }

  @action
  void setDebit(Debit debit) => debitList.add(debit);

  @action
  void setValorDepositar(num? value) {
    print('entrou o valor: $value');
    valorADepositar = value;
  }

  @computed
  bool get valorDepositarValid =>
      valorADepositar != null && valorADepositar! > 0;
  String? get valorDepositarError {
    if (valorDepositarValid) {
      return null;
    } else {
      return 'O Valor a depositar tem que ser maior que zero';
    }
  }
}
