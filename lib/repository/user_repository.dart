import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:target_flutter/repository/table_keys.dart';

import '../model/user.dart';
import 'parse_errors.dart';

class UserRepository {
  Future<User> signUp(User user) async {
    final parseUser = ParseUser(
      user.email,
      user.pass!,
      user.email,
    );

    parseUser.set<String>(keyUserName, user.user!);

    final response = await parseUser.signUp();

    if (response.success) {
      return mapParseToUser(response.result);
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code));
    }
  }

  Future<User> loginWithEmail(String email, String password) async {
    print('loginWithEmail()');
    final parseUser = ParseUser(email, password, null);

    final response = await parseUser.login();

    print('loginWithEmail -> $response');

    if (response.success) {
      return mapParseToUser(response.result);
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code));
    }
  }

  User mapParseToUser(ParseUser parseUser) {
    print('mapParserToUser = $parseUser');
    return User(
      user: parseUser.get(keyUserName),
      email: parseUser.get(keyUserEmail),
      id: parseUser.objectId,
      createAt: parseUser.get(keyUserCreatedAt),
    );
  }

  Future<User?> currentUser() async {
    final parseUser = await ParseUser.currentUser();

    if (parseUser != null) {
      final response =
          await ParseUser.getCurrentUserFromServer(parseUser.sessionToken);
      if (response!.success) {
        return mapParseToUser(response.result);
      } else {
        await parseUser.logout();
      }
    }

    return null;
  }

  Future<void> save(User user) async {
    final ParseUser parseUser = await ParseUser.currentUser();

    if (parseUser != null) {
      parseUser.set<String>(keyUserName, user.user!);

      if (user.pass != null) {
        parseUser.password = user.pass!;
      }

      final response = await parseUser.save();

      if (!response.success) {
        return Future.error(ParseErrors.getDescription(response.error!.code));
      }

      if (user.pass != null) {
        await parseUser.logout();

        final loginResponse =
            await ParseUser(user.email, user.pass!, user.email).login();

        if (!loginResponse.success) {
          return Future.error(ParseErrors.getDescription(response.error!.code));
        }
      }
    }
  }

  Future<void> logout() async {
    final ParseUser currentUser = await ParseUser.currentUser();
    await currentUser.logout();
  }
}
