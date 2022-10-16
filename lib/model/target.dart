import 'package:get_it/get_it.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/repository/table_keys.dart';
import 'package:target_flutter/repository/user_repository.dart';
import 'package:target_flutter/stores/user_manager_store.dart';

import 'user.dart';

class Target {
  String? id;
  String? descricao;
  num? valorAtual;
  num? valorFinal;
  num? progress;
  User? user;
  DateTime? createAd;
  TypeDebit tipoValor = TypeDebit.REAL;

  Target({this.id, this.descricao, this.valorFinal, this.user, required this.tipoValor});

  Target.fromParse(ParseObject object) {
    id = object.objectId;
    descricao = object.get<String>(keyTargetDescricao);
    valorFinal = object.get<num>(keyTargetFinal);
    //user = GetIt.I<UserManagerStore>().user!;
    createAd = object.get<DateTime>(keyDebitData);
    var auxTipo = object.get<num>(keyTargetTypeValue);

    if (auxTipo == null || auxTipo == 1) {
      tipoValor = TypeDebit.REAL;
    } else if (auxTipo == 2) {
      tipoValor = TypeDebit.DOLLAR;
    }
  }

  @override
  String toString() {
    return "Target = {id: $id, descricao: $descricao, valorFinal: $valorFinal, user: $user, create: $createAd}";
  }
}
