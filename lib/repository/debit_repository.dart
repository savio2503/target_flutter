import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:target_flutter/model/debit.dart';
import 'package:target_flutter/repository/parse_errors.dart';
import 'package:target_flutter/repository/table_keys.dart';

import '../model/target.dart';

class DebitRepository {
  Future<num> getSomeDebitFromTarget(Target target) async {
    try {
      print('getSomeDebitFromTarget');
      //final currentUser = ParseUser('', '', '')..set(keyUserId, target.user!);
      final targetObject = ParseObject(keyTargetTable)
        ..set(keyTargetId, target.id!);
      final queryBuilder =
          QueryBuilder<ParseObject>(ParseObject(keyDebitTable));

      queryBuilder.orderByDescending(keyDebitData);
      //queryBuilder.whereEqualTo(keyDebitUser, currentUser.toPointer());
      queryBuilder.whereEqualTo(keyDebitTarget, targetObject.toPointer());

      //print('getSomeDebitFromTarget, query: $queryBuilder');

      final response = await queryBuilder.query();

      if (response.success && response.results != null) {
        List<Debit> debits =
            response.results!.map((de) => Debit.fromParse(de)).toList();

        num some = 0;

        for (var debit in debits) {
          some += debit.valor!;
        }

        return some;
      } else if (response.success && response.results == null) {
        return 0;
      } else {
        return Future.error(ParseErrors.getDescription(response.error!.code));
      }
    } catch (e) {
      return Future.error('error ao buscar os debitos');
    }
  }

  Future<Debit> save(Debit debit) async {
    try {
      print('save');
      final parseUser = ParseUser('', '', '')..set(keyUserId, debit.user!.id!);

      final debitObject = ParseObject(keyDebitTable);

      if (debit.id != null) debitObject.objectId = debit.id!;

      final parseAcl = ParseACL(owner: parseUser);
      parseAcl.setPublicReadAccess(allowed: true);
      parseAcl.setPublicWriteAccess(allowed: false);
      debitObject.setACL(parseAcl);

      debitObject.set<num>(keyDebitValor, debit.valor!);
      debitObject.set<ParseObject>(keyDebitTarget,
          ParseObject(keyTargetTable)..set(keyTargetId, debit.target!.id!));

      final response = await debitObject.save();

      if (!response.success) {
        return Future.error(ParseErrors.getDescription(response.error!.code));
      } else {
        return Debit.fromParse(response.result);
      }
    } catch (e) {
      return Future.error("Erro ao salvar o debito");
    }
  }

  Future<List<Debit>> getAllDebit(Target target) async {
    try {
      print('getAllDebit');
      final currentUser = ParseUser('', '', '')..set(keyUserId, target.user!);
      final targetObject = ParseObject(keyTargetTable)
        ..set(keyTargetId, target.id!);
      final queryBuilder =
          QueryBuilder<ParseObject>(ParseObject(keyDebitTable));

      queryBuilder.orderByDescending(keyDebitData);
      queryBuilder.whereEqualTo(keyDebitUser, currentUser.toPointer());
      queryBuilder.whereEqualTo(keyDebitTarget, targetObject.toPointer());

      final response = await queryBuilder.query();

      if (response.success && response.results != null) {
        return response.results!.map((de) => Debit.fromParse(de)).toList();
      } else if (response.success && response.results == null) {
        return [];
      } else {
        return Future.error(ParseErrors.getDescription(response.error!.code));
      }
    } catch (e) {
      return Future.error('error ao buscar os debitos');
    }
  }
}
