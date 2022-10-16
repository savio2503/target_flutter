import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:target_flutter/model/target.dart';
import 'package:target_flutter/model/user.dart';
import 'package:target_flutter/repository/table_keys.dart';

import '../repository/user_repository.dart';

enum TypeDebit { REAL, DOLLAR }

class Debit {
  String? id;
  num? valor;
  DateTime? create;
  User? user;
  Target? target;
  TypeDebit tipo = TypeDebit.REAL;

  Debit({this.id, this.valor, this.create, this.user, this.target, required this.tipo});

  Debit.fromParse(ParseObject object) {
    id = object.objectId;
    valor = object.get<num>(keyDebitValor);
    create = object.get<DateTime>(keyDebitData);
    var auxTipo = object.get<num>(keyDebitType);

    if (auxTipo == null || auxTipo == 1) {
      tipo = TypeDebit.REAL;
    } else if (auxTipo == 2) {
      tipo = TypeDebit.DOLLAR;
    }
    //user =
    //    UserRepository().mapParseToUser(object.get<ParseUser>(keyDebitUser)!);
    target = Target.fromParse(object.get<ParseObject>(keyDebitTarget)!);
  }

  @override
  String toString() {
    return "Debit = {id = $id, valor: $valor, create: $create, user: $user, target: $target, tipo: $tipo}";
  }
}
