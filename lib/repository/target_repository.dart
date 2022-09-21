import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:target_flutter/repository/table_keys.dart';

import '../model/target.dart';
import 'parse_errors.dart';

class TargetRepository {
  Future<List<Target>> getMainTargetList({required int page}) async {
    print('1getMainTargetList $page');
    try {
      final queryBuilder =
          QueryBuilder<ParseObject>(ParseObject(keyTargetTable));

      queryBuilder.setLimit(10);

      queryBuilder.orderByAscending(keyTargetDescricao);

      final response = await queryBuilder.query();

      print('2getMainTargetList ${response.results}');

      if (response.success && response.results != null) {
        return response.results!.map((po) => Target.fromParse(po)).toList();
      } else if (response.success && response.results == null) {
        return [];
      } else {
        return Future.error(ParseErrors.getDescription(response.error!.code));
      }
    } catch (e) {
      return Future.error('Falha na conexão');
    }
  }

  Future<void> save(Target target) async {
    print('1TargetRepository: $target');
    try {
      final parseUser = ParseUser('', '', '')..set(keyUserId, target.user!.id!);

      final targetObject = ParseObject(keyTargetTable);

      if (target.id != null) targetObject.objectId = target.id;

      final parseAcl = ParseACL(owner: parseUser);
      parseAcl.setPublicReadAccess(allowed: true);
      parseAcl.setPublicWriteAccess(allowed: false);
      targetObject.setACL(parseAcl);

      targetObject.set<String>(keyTargetDescricao, target.descricao!);
      targetObject.set<double>(keyTargetFinal, target.valorFinal!);

      final response = await targetObject.save();

      if (!response.success) {
        return Future.error(ParseErrors.getDescription(response.error!.code));
      }
    } catch (e) {
      return Future.error('Falha ao salvar anúncio');
    }
  }
}
