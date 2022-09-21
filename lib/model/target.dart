import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:target_flutter/repository/table_keys.dart';
import 'package:target_flutter/repository/user_repository.dart';

import 'user.dart';

class Target {
  String? id;
  String? descricao;
  double? valorFinal;
  User? user;

  Target({this.id, this.descricao, this.valorFinal, this.user});

  Target.fromParse(ParseObject object) {
    id = object.objectId;
    descricao = object.get<String>(keyTargetDescricao);
    valorFinal = object.get<double>(keyTargetFinal);
    user =
        UserRepository().mapParseToUser(object.get<ParseUser>(keyTargetUser)!);
  }

  @override
  String toString() {
    return "Target = {descricao: $descricao, valorFinal: $valorFinal}";
  }
}
