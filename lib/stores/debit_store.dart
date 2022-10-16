import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/model/target.dart';
import 'package:target_flutter/repository/debit_repository.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

part 'debit_store.g.dart';

class DebitStore = _DebitStore with _$DebitStore;

abstract class _DebitStore with Store {
  Future<List<Debit>> getAllDebit(Target target) async {
    List<Debit> result = <Debit>[];

    try {
      result = await DebitRepository().getAllDebit(target);
    } catch (e) {
      print('erro ao buscar os debitos: ${e.toString()}');
    }

    return result;
  }

  Future<Debit?> saveDebit(Target target, num valor, TypeDebit tipo) async {
    try {
      Debit debit = Debit(valor: valor, target: target, user: GetIt.I<UserManagerStore>().user, tipo: tipo);

      Debit result = await DebitRepository().save(debit);

      print('resultado salvamento debit: $result');

      return result;
    } catch (e) {
      print('erro ao salvar o debito: ${e.toString()}');
    }
  }
}
