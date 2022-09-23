import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:target_flutter/model/target.dart';
import 'package:target_flutter/model/user.dart';
import 'package:target_flutter/repository/table_keys.dart';

import '../repository/user_repository.dart';

class Debit {
  String? id;
  num? valor;
  DateTime? create;
  User? user;
  Target? target;

  Debit({this.id, this.valor, this.create, this.user, this.target});

  Debit.fromParse(ParseObject object) {
    id = object.objectId;
    valor = object.get<num>(keyDebitValor);
    create = object.get<DateTime>(keyDebitData);
    //user =
    //    UserRepository().mapParseToUser(object.get<ParseUser>(keyDebitUser)!);
    target = Target.fromParse(object.get<ParseObject>(keyDebitTarget)!);
  }

  @override
  String toString() {
    return "Debit = {id = $id, valor: $valor, create: $create, user: $user, target: $target}";
  }
}
