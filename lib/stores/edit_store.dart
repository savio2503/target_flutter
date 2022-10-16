import 'package:mobx/mobx.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/model/target.dart';
import 'package:target_flutter/repository/debit_repository.dart';
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

  @observable
  bool edit = false;

  ObservableList<Debit> debitList = ObservableList<Debit>();

  @observable
  TypeDebit tipoDeposito = TypeDebit.REAL;

  @action
  void setTipoDeposito(TypeDebit value) => tipoDeposito = value;

  @action
  Future<void> setTarget(Target target) async {
    descricao = target.descricao!;
    print('setTarget: ${target.valorFinal}');
    valorFinal = target.valorFinal;
    idTarget = target.id!;
    edit = false;

    reloadDebit(target);
  }

  @action
  Future<void> reloadDebit(Target target) async {
    debitList.clear();

    final _debits = await DebitStore().getAllDebit(target);

    debitList.addAll(_debits);
  }

  @action
  void setDescricao(String? value) {
    edit = true;
    descricao = value;
  }

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
  void setFinal(num? value) {
    edit = true;
    valorFinal = value;
  }

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
  void setDebit(Debit debit) {
    edit = true;
    debitList.add(debit);
  }

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

  @action
  Future<void> removeDebit(int indice) async {
    print('apertou para deletar o debito');
    try {
      loading = true;

      var _debit = debitList[indice];

      print('deletando o debito $_debit');

      DebitRepository().deleteDebit(_debit);

      print('deletou com sucesso!');

      debitList.removeAt(indice);
      edit = true;

      loading = false;
    } catch (e) {
      print(e);
    }
  }
}
